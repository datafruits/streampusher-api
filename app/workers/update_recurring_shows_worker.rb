class UpdateRecurringShowsWorker < ActiveJob::Base
  queue_as :default

  def perform scheduled_show_id, update_all_recurrences
    scheduled_show = ScheduledShow.find scheduled_show_id
    scheduled_show.update_all_recurrences = ActiveModel::Type::Boolean.new.cast(update_all_recurrences)
    scheduled_show.update_recurrences
  end
end
