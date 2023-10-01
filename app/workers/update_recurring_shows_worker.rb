class UpdateRecurringShowsWorker < ActiveJob::Base
  queue_as :default

  def perform show_series_id
    show_series = ShowSeries.find show_series_id
    show_series.update_episodes
  end
end
