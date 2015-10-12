class SaveRecordingWorker
  include Sidekiq::Worker

  def perform filename, radio_name
    SaveRecording.save filename, radio_name
  end
end
