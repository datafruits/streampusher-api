class ProcessRecordingWorker < ActiveJob::Base
  queue_as :default

  def perform recording_id
    recording = Recording.find(recording_id)

    ProcessRecordingWorker.new.perform(recording)

  end
end
