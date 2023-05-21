class StreamingExpAwardWorker < ActiveJob::Base
  queue_as :default

  def perform track_id
    track = Track.find track_id

    StreamingExpAward.perform track
  end
end
