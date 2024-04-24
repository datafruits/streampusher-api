require 'csv'

csv_path = "/tmp/guestfruits.csv"

CSV.foreach(csv_path, headers: true) do |row|
  show_series_slug = row["show_series_slug"]
  if show_series_slug
    slug = row["show_slug"]
    episode = ScheduledShow.friendly.find slug
    show_series = ShowSeries.friendly.find show_series_slug
    episode.update! show_series_id: show_series.id
  end
end
