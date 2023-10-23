class ProcessRecordingWorker < ActiveJob::Base
  queue_as :process_recordings

  def perform recording_id, scheduled_show_id = nil
    recording = Recording.find(recording_id)
    if scheduled_show_id
      scheduled_show = ScheduledShow.find scheduled_show_id
      ProcessRecording.new.perform(recording, scheduled_show)
    else
      ProcessRecording.new.perform(recording)
    end
  end
end
