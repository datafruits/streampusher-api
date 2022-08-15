class TracksController < ApplicationController
  load_and_authorize_resource
  before_action :set_frame_headers, only: [:embed]
  before_action :current_radio_required, only: [:embed]

  def index
    @tracks = @current_radio.tracks.includes(:labels)
    if params[:search]
      @tracks = @tracks.where("title ilike (?) or audio_file_name ilike (?)",
                              "%#{params[:search].permit(:keyword)[:keyword]}%",
                             "%#{params[:search].permit(:keyword)[:keyword]}%")
    end
    @tracks = @tracks.page(params[:page])

    respond_to do |format|
      format.html
      format.json {
        meta = { page: params[:page], total_pages: @tracks.total_pages.to_i }
        render json: @tracks, meta: meta
      }
    end
  end

  def show
    @track = @current_radio.tracks.find params[:id]
    respond_to do |format|
      format.json {
        render json: @track
      }
    end
  end

  def edit
    @track = @current_radio.tracks.find params[:id]
  end

  def update
    @track = @current_radio.tracks.find params[:id]
    if update_params[:artwork].present?
      artwork = Paperclip.io_adapters.for(update_params[:artwork])
      artwork.original_filename = update_params.delete(:artwork_filename)
      @track.attributes = update_params.except(:artwork_filename).merge({artwork: artwork})
    else
      @track.attributes = update_params.except(:artwork_filename).except(:artwork)
    end
    if @track.save
      ActiveSupport::Notifications.instrument 'track.updated', current_user: current_user.email, radio: @current_radio.name, track: @track.file_basename, params: update_params.except(:artwork)
      render json: @track
    else
      render json: @track.errors
    end
  end

  def create
    @track = @current_radio.tracks.new create_params
    @track.uploaded_by = current_user
    if @track.save
      ActiveSupport::Notifications.instrument 'track.created', current_user: current_user.email, radio: @current_radio.name, track: @track.file_basename
      render json: @track
    else
      render json: @track.errors
    end
  end

  def destroy
    @track = @current_radio.tracks.find params[:id]
    if @track.destroy
      render json: @track
    else
      render json: @track.errors
    end
  end

  def embed
    @radio = @current_radio
    @track = Track.find(params[:id])
    render :layout => false
  end

  private
  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :radio_id, :audio_file_name, :filesize, :label_ids
    ])
  end

  def update_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :artist, :title, :album, :artwork, :audio_file_name,
      :artwork_filename, :scheduled_show_id, label_ids: []
    ])
  end

  def set_frame_headers
    response.headers.delete "X-Frame-Options"
  end
end
