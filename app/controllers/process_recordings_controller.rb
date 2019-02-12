class ProcessRecordingsController < ApplicationController
  def create
    ProcessRecordingWorker.perform_later params[:recording_id]

    redirect_to recordings_path
  end
end
