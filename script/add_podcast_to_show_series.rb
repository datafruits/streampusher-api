require 'csv'

csv_path = "/tmp/missing_podcasts.csv"

CSV.foreach(csv_path, headers: true) do |row|
  # show_title = row[:show_series]
  slug = row[:show_series_slug]
  show_series = ShowSeries.friendly.find slug
  track = Track.find_by(title: row[:title])
  if show_series
    episode = show_series.scheduled_shows.new title: row[:title], start_at: row[:created_at], end_at: row[:created_at], status: "archive_published"
    episode.save!
    track.update scheduled_show: episode
  end
end
