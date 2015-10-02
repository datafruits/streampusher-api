class SaveRecordingWorker < ActiveJob::Base
  queue_as :default

  def perform filename
    SaveRecording.save filename
  end
end
