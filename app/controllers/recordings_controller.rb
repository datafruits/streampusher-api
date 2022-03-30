class RecordingsController < ApplicationController
  load_and_authorize_resource
  def index
    @recordings = @current_radio.recordings.unscoped.order("file_created_at DESC")
    @recordings = @recordings.page(params[:page])
    respond_to do |format|
      format.html
      format.json {
        meta = { page: params[:page], total_pages: @recordings.total_pages.to_i }
        render json: @recordings, meta: meta
      }
    end
  end

  def show
    send_file @recording.path
  end
end
