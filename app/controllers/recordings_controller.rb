class RecordingsController < ApplicationController
  def index
    authorize! :index, Recording
    @recordings = @current_radio.recordings.unscoped.order("file_created_at DESC")
    if params[:term]
      @recordings = @recordings.where("path ilike (?)", "%#{params.permit(:term)[:term]}%")
    end
    @recordings = @recordings.page(params[:page])
    meta = { page: params[:page], total_pages: @recordings.total_pages.to_i }
    render json: @recordings, meta: meta
  end

  def show
    @recording = @current_radio.recordings.find(params[:id])
    send_file @recording.path
  end
end
