require 'csv'

csv_path = "/tmp/guestfruits.csv"

datafruits = Radio.first

CSV.foreach(csv_path, headers: true) do |row|
  show_series_slug = row["show_series_slug"]
  username = row["show_dj"]
  if show_series_slug
    slug = row["show_slug"]
    episode = ScheduledShow.friendly.find slug
    show_series = ShowSeries.friendly.find show_series_slug
    episode.update! show_series_id: show_series.id
  else
    user = User.find_by username: username
    if !user
      puts "couldn't find user: #{username}, creating"
        user = datafruits.users.create! username: username, password: "", password_confirmation: "", email: "test@datafruits.fm"
    end
    show = ScheduledShow.friendly.find(row["show_slug"])
    show.update! user: user
  end
end
