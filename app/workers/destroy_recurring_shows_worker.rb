class DestroyRecurringShowsWorker < ActiveJob::Base
  queue_as :default

  def perform scheduled_show_id
    scheduled_show = ScheduledShow.find scheduled_show_id
    scheduled_show.do_destroy_recurrences
  end
end
