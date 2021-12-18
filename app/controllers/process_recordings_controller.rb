class ProcessRecordingsController < ApplicationController
  def create
    ProcessRecordingWorker.perform_later params[:recording_id]

    respond_to do |format|
      format.json {
        @recording = @current_radio.recordings.find(params[:recording_id])
        render json: @recording
      }
      format.html {
        redirect_to recordings_path
      }
    end
  end
end
