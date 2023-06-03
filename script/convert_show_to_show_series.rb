shows = Radio.first.scheduled_shows.where(recurrence: false)
guest_series = ShowSeries.find_or_create_by(title: "GuestFruits")

shows.find_each do |show|
  if show.recurrences.count > 0 && show.recurrant_original_id.nil? && show.recurring_interval != "not_recurring"
    # create a show series that repeats
    puts "creating show series for #{show.title}"
    show_series = ShowSeries.new title: show.title, description: show.description, recurring_interval: show.recurring_interval
    show_series.save!
    show.recurrences.update_all show_series_id: show_series.id
  elsif !show.recurrence?
    puts "adding #{show.title} to guest series"
    # add to guest shows
    show.update show_series_id: guest_series.id
  end
end
