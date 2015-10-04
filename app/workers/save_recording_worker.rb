class SaveRecordingWorker < ActiveJob::Base
  queue_as :default

  def perform filename, radio_name
    SaveRecording.save filename, radio_name
  end
end
