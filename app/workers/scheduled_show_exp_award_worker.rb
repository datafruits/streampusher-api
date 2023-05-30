class ScheduledShowExpAwardWorker < ActiveJob::Base
  queue_as :default

  def perform scheduled_show_id
    scheduled_show = ScheduledShow.find scheduled_show_id
    ScheduledShowExpAward.perform scheduled_show
  end
end
