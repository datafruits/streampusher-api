headers = [
  'show_slug',
  'show_title',
  'show_dj',
  'track_title', # (if track)
  'track_audio_file_name',
  'show_series_slug', #(fill this in)
]

guest_fruits = ShowSeries.find_by(title: "GuestFruits")

CSV.open("/tmp/guest_fruits.csv", "wb", write_headers: true, headers: headers) do |csv|
  guest_fruits.episodes.find_each do |episode|
    # only episodes with tracks
    if episode.tracks.any?
      row = []
      row << episode.slug
      row << episode.title
      row << episode.dj.username
      row << episode.tracks.first.title
      row << episode.tracks.first.audio_file_name
      csv << row
    end
  end
end
