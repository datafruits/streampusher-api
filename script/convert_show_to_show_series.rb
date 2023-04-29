shows = Radio.first.scheduled_shows.where(recurrence: false)

shows.find_each do |show|
  if show.recurrences.count > 0 && show.recurrant_original_id.nil? && show.recurring_interval != "not_recurring"
    # create a show series that repeats
    show_series = ShowSeries.new title: show.title, description: show.description, recurring_interval: show.recurring_interval
    show_series.save!
  else
    # add to guest shows
  end
end
