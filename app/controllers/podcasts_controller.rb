class PodcastsController < ApplicationController
  include ActionController::MimeResponds
  include ActionView::Layouts
  include ActionController::Rendering

  load_and_authorize_resource except: [:index, :show]
  before_action :current_radio_required, only: [:index, :show]
  serialization_scope :serializer_scope

  def index
    @podcasts = @current_radio.podcasts
    @podcast = Podcast.new
    respond_to do |format|
      format.json do
        authorize! :index, Podcast
        render json: @podcasts
      end
      format.html do
        @query = params[:query].to_s.strip
        @tags = Array(params[:tags]).flat_map { |tag| tag.to_s.split(',') }.map(&:strip).reject(&:blank?).uniq
        @labels = @current_radio.labels.order(:name)
        @archives = @current_radio.scheduled_shows.archive_published.
          where('end_at < ?', Time.current).
          where(id: Track.where(radio_id: @current_radio.id).where.not(audio_file_name: [nil, '']).select(:scheduled_show_id)).
          includes(:labels, :performers, :tracks, :show_series).
          order(start_at: :desc, id: :desc)
        if @query.present?
          @archives = @archives.where('title ILIKE ?', "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%")
        end
        @tags.each do |tag|
          label_ids = @current_radio.labels.where('LOWER(name) = ?', tag.downcase).select(:id)
          @archives = @archives.where(id: ScheduledShowLabel.where(label_id: label_ids).select(:scheduled_show_id))
        end
        @archives = @archives.page(params[:page]).per(20)
        if datastar_request?
          html = render_to_string(partial: 'archives')
          url = podcasts_path(query: @query.presence, tags: @tags.presence, page: params[:page])
          datastar.stream do |sse|
            sse.patch_elements(html)
            sse.execute_script("history.replaceState(null, '', #{url.to_json});")
          end
        else
          render :index
        end
      end
    end
  end

  def create
    if @podcast.save
      ActiveSupport::Notifications.instrument 'podcast.created', current_user: current_user.email, radio: @current_radio.name, podcast: @podcast.name
      redirect_to podcasts_path
    else
      @podcasts = @current_radio.podcasts
      render 'index'
    end
  end

  def edit
    @podcast = @current_radio.podcasts.find params[:id]
  end

  def update
    @podcast.attributes = podcast_params
    if @podcast.save
      redirect_to podcasts_path
    else
      @podcasts = @current_radio.podcasts
      render 'index'
    end
  end

  def show
    @podcast = @current_radio.podcasts.find_by_name(params[:id])

    @archives = Rails.cache.fetch("chronological_archives/#{@current_radio.id}") {
      Rails.log.info("Recaching archives....")

      @current_radio.scheduled_shows.
        includes([:tracks]).
        where(status: :archive_published).
        order("start_at DESC")
    }

    respond_to do |format|
      format.xml {
        render 'show', layout: false
      }
    end
  end

  private
  def podcast_params
    params.require(:podcast).permit(:name, :playlist_id, :radio_id, :image)
  end

  def serializer_scope
    if params[:tags].is_a? String
      tags = Array(params[:tags].split(","))
    else
      tags = Array(params[:tags])
    end
    {
      tracks: {
        page: params[:page],
        query: params[:query],
        tags: tags
      }
    }
  end
end
