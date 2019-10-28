class UpdateRecurringShowsWorker < ActiveJob::Base
  queue_as :default

  def perform scheduled_show_id
    scheduled_show = ScheduledShow.find scheduled_show_id
    scheduled_show.update_recurrences
  end
end
