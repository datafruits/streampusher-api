class DestroyRecurringShowsWorker < ActiveJob::Base
  queue_as :default

  def perform recurrant_original_id
    recurrances = ScheduledShow.where(recurrant_original_id: recurrant_original_id)
                               .or(ScheduledShow.where(id: recurrant_original_id))
                               .where("start_at > (?)", Time.now)
    recurrances.destroy_all
  end
end
