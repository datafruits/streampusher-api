class Api::TracksController < ApplicationController
  load_and_authorize_resource except: [:index, :show]
  before_action :current_radio_required

  def index
    @tracks = @current_radio.tracks.order("created_at DESC")

    if params[:id]
      @tracks = @current_radio.tracks.where("id in (?)", params[:id])
    end

    if params[:my] && !current_user.has_role?("admin")
      @tracks = @tracks.where(uploaded_by: current_user)
    end

    if params[:term]
      @tracks = @tracks.where("audio_file_name ilike (?) OR title ilike (?)", "%#{params.permit(:term)[:term]}%", "%#{params.permit(:term)[:term]}%")
    end

    @tracks = @tracks.page(params[:page])
    meta = { page: params[:page], total_pages: @tracks.total_pages.to_i }
    render json: @tracks
  end

  def show
    @track = @current_radio.tracks.find params[:id]

    render json: @track
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

  private
  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :radio_id, :audio_file_name, :filesize, :label_ids
    ])
  end
end
