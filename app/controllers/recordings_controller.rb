class RecordingsController < ApplicationController
  load_and_authorize_resource
  def index
    @recordings = @current_radio.recordings
  end

  def show
    send_file @recording.path
  end
end
