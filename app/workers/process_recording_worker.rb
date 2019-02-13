class ProcessRecordingWorker < ActiveJob::Base
  queue_as :process_recordings

  def perform recording_id
    recording = Recording.find(recording_id)

    ProcessRecording.new.perform(recording)

  end
end
