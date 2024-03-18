require 'csv'

csv_path = "/tmp/missing_podcasts.csv"

CSV.foreach(csv_path, headers: true) do |row|
  slug = row[:show_series_slug]
  if slug
    show_series = ShowSeries.friendly.find slug
    track = Track.find_by(title: row[:audio_file_name])
    if show_series
      title = row[:title]
      # strip date from show if it exists, somehow
      episode = show_series.scheduled_shows.new title: title, start_at: row[:created_at], end_at: row[:created_at], status: "archive_published"
      episode.save!
      track.update scheduled_show: episode
      episode.labels << track.labels
    end
  else
    title = row[:show_series]
    show_series = ShowSeries.find_by title: title
    if show_series
    else
      # create it
      # ShowSeries.create user: ???
    end
  end
end
