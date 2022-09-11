class ScheduledShowsController < ApplicationController
  load_and_authorize_resource except: [:create, :edit, :update, :destroy]
  before_action :current_radio_required, only: [:index, :edit]

  def new
    performer = @scheduled_show.scheduled_show_performers.build
    performer.user = current_user
  end

  def edit
    @scheduled_show = @current_radio.scheduled_shows.friendly.find(params[:id])
    authorize! :edit, @scheduled_show
  end

  def index
    if params[:term]
      @scheduled_shows = @current_radio.scheduled_shows.where("title ilike ?", "%#{params[:term]}%").order("start_at DESC").includes(:performers, :scheduled_show_performers, :tracks, [:playlist])
    else
      if params[:start]
        start_at = DateTime.parse(params[:start]).in_time_zone(Time.zone.name)
      else
        start_at = 1.month.ago
      end
      @scheduled_shows = @current_radio.scheduled_shows.where("start_at >= ? AND end_at <= ?", start_at, params[:end]).order("start_at ASC").includes(:performers, :scheduled_show_performers, :tracks, [:playlist])
    end

    response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
    render json: Fast::ScheduledShowSerializer.new(@scheduled_shows).serializable_hash.to_json
  end

  def show
    response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
    render json: @scheduled_show
  end

  def next
    @scheduled_show = @current_radio.next_scheduled_show
    response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
    render json: @scheduled_show
  end

  def create
    authorize! :create, ScheduledShow
    if create_params[:image].present?
      image = Paperclip.io_adapters.for(create_params[:image])
      image.original_filename = create_params.delete(:image_filename)
      @scheduled_show = @current_radio.scheduled_shows.new create_params.except(:image_filename).merge({image: image})
    else
      @scheduled_show = @current_radio.scheduled_shows.new create_params.except(:image_filename).except(:image)
    end
    @scheduled_show.dj_id = current_user.id
    scheduled_show_performers_params[:dj_ids].each do |id|
      @scheduled_show.scheduled_show_performers << ScheduledShowPerformer.new(user_id: id)
    end
    if @scheduled_show.save
      ActiveSupport::Notifications.instrument 'scheduled_show.created', current_user: current_user.email, radio: @current_radio.name, show: @scheduled_show.title
      render json: @scheduled_show
    else
      render json: @scheduled_show.errors, status: :unprocessable_entity
    end
  end

  def update
    @scheduled_show = @current_radio.scheduled_shows.friendly.find(params[:id])
    authorize! :update, @scheduled_show
    if create_params[:image].present?
      image = Paperclip.io_adapters.for(create_params[:image])
      image.original_filename = create_params.delete(:image_filename)
      @scheduled_show.attributes = create_params.except(:image_filename).merge({image: image})
    else
      @scheduled_show.attributes =  create_params.except(:image_filename).except(:image)
    end
    if @scheduled_show.save
      ActiveSupport::Notifications.instrument 'scheduled_show.updated', current_user: current_user.email, radio: @current_radio.name, show: @scheduled_show.title, params: create_params
      render json: @scheduled_show
    else
      render json: @scheduled_show.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @scheduled_show = @current_radio.scheduled_shows.friendly.find(params[:id])
    authorize! :destroy, @scheduled_show
    @scheduled_show.destroy_recurrences = params[:destroy_recurrences]
    @scheduled_show.destroy
    ActiveSupport::Notifications.instrument 'scheduled_show.deleted', current_user: current_user.email, radio: @current_radio.name, show: @scheduled_show.title
    redirect_to scheduled_shows_path
  end

  private
  def scheduled_show_performers_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :djs
    ])
  end

  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :radio_id, :start_at,
      :end_at, :description, :image, :image_filename, :update_all_recurrences,
      :recurring_interval, :playlist, :time_zone,
      :start, :end, :is_guest, :guest, :is_live,
    ])
  end
end
