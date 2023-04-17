class StreamingExpAwardWorker < ActiveJob::Base
  def perform track_id
    track = Track.find track_id

    StreamingExpAward.perform track
  end
end
