class StreamingExpAwardWorker < ActiveJob::Base
  queue_as :default

  def perform track_id, show_id
    track = Track.find track_id
    show = ScheduledShow.find show_id

    StreamingExpAward.perform track, show
  end
end
