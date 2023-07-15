shows = Radio.first.scheduled_shows.where(recurrence: false)
guest_series = ShowSeries.find_or_initialize_by(title: "GuestFruits")
guest_series.description = "Guest shows"
# guest series start_time ????
guest_series.start_time = Date.today
guest_series.end_time = Date.today
guest_series.start_date = Date.today
guest_series.save!

shows.find_each do |show|
  if show.recurrences.count > 0 && show.recurrant_original_id.nil? && show.recurring_interval != "not_recurring"
    if show.dj.present?
      # create a show series that repeats
      puts "creating show series for #{show.title}"
      show_series = ShowSeries.new title: show.title, description: show.description, recurring_interval: show.recurring_interval, start_time: show.start_at, end_time: show.end_at, start_date: show.start_at, status: "disabled"
      if show_series.description.blank?
        show_series.description = show_series.title
      end
      # show_series.image = show.image if show.image.present?
      show_series.show_series_hosts.build user: show.dj
      show.performers.each do |user|
        unless user.id === show.dj.id
          show_series.show_series_hosts.build user: user
        end
      end
      show_series.save!
      show.recurrences.update_all show_series_id: show_series.id
    else
      puts "no dj present for this show :(...better fix it later!"
    end
  elsif !show.recurrence?
    puts "adding #{show.title} to guest series"
    # add to guest shows
    show.update show_series_id: guest_series.id
  end
end
