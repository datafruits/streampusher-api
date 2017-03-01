class RecordingsController < ApplicationController
  load_and_authorize_resource
  def index
    @recordings = @current_radio.recordings
  end

  def create
    @recording = current_radio.recordings.new recording_params
  end

  private
  def recording_params
    params.require(:recording).permit(:audio_file_name)
  end
end
