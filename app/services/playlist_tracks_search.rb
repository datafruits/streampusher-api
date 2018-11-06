class PlaylistTracksSearch
  def self.perform  playlist_tracks, query, tags
    playlist_tracks.joins(:track).where("track.title LIKE ?", query)
  end
end
