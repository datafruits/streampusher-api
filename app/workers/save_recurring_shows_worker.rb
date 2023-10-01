class SaveRecurringShowsWorker < ActiveJob::Base
  queue_as :default

  def perform scheduled_show_id
    scheduled_show = ScheduledShow.find scheduled_show_id
    scheduled_show.save_recurrences
  end
end
