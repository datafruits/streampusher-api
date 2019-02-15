class RecordingsController < ApplicationController
  load_and_authorize_resource
  def index
    @recordings = @current_radio.unscoped.recordings.order("file_created_at DESC")
  end

  def show
    send_file @recording.path
  end
end
