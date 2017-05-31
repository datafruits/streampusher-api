class TracksController < ApplicationController
  load_and_authorize_resource
  before_action :set_frame_headers, only: [:embed]
  before_action :current_radio_required, only: [:embed]

  def index
    @tracks = @current_radio.tracks.includes(:labels)
    respond_to do |format|
      format.html
      format.json {
        render json: @tracks
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
      flash[:notice] = 'track tags updated!'
      ActiveSupport::Notifications.instrument 'track.updated', current_user: current_user.email, radio: @current_radio.name, track: @track.file_basename, params: update_params.except(:artwork)
      render json: @track
    else
      flash[:error] = 'error updating track tags :('
      render json: @track.errors
    end
  end

  def create
    @track = @current_radio.tracks.new create_params
    if @track.save
      ActiveSupport::Notifications.instrument 'track.created', current_user: current_user.email, radio: @current_radio.name, track: @track.file_basename
      flash[:notice] = 'track uploaded!'
      render json: @track
    else
      flash[:error] = 'error uploading track :('
      render json: @track.errors
    end
  end

  def destroy
    @track = @current_radio.tracks.find params[:id]
    if @track.destroy
      flash[:notice] = "removed track!"
      render json: @track
    else
      flash[:error] = "error destroying track. try again?"
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
    params.require(:track).permit(:radio_id, :audio_file_name, :filesize, label_ids: [])
  end

  def update_params
    params.require(:track).permit(:artist, :title, :album, :artwork, :artwork_filename, label_ids: [])
  end

  def set_frame_headers
    response.headers.delete "X-Frame-Options"
  end
end
