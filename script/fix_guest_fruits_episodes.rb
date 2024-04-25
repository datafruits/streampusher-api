require 'csv'

csv_path = "/tmp/guestfruits.csv"

datafruits = Radio.first

CSV.foreach(csv_path, headers: true) do |row|
  show_series_slug = row["show_series_slug"].strip
  username = row["show_dj"]
  if !show_series_slug.blank?
    slug = row["show_slug"]
    episode = ScheduledShow.friendly.find slug
    show_series = ShowSeries.friendly.find show_series_slug
    episode.update! show_series_id: show_series.id, status: "archive_published"
  else
    user = User.where("username ilike ?", "%#{username.strip}%").first
    if !user
      # generate a random string for password
      puts "couldn't find user: #{username}, creating"
      rand1 = SecureRandom.hex(10)
      rand2 = SecureRandom.hex(10)
      user = datafruits.users.create! username: username.strip, password: rand1, password_confirmation: rand1, email: "test#{rand2}@datafruits.fm"
    end
    show = ScheduledShow.friendly.find(row["show_slug"])
    show.update! status: "archive_published"
    if show.dj.id != user.id
      show.update! dj: user
    end
  end
end
