class ProcessRecordingsController < ApplicationController
  def create
    ProcessRecordingWorker.perform_later params[:recording_id]

    @recording = @current_radio.recordings.find(params[:recording_id])
    render json: @recording
  end
end
