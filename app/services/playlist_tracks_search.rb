class PlaylistTracksSearch
  def self.perform  playlist_tracks, query, tags=[]
    if tags.present?
      labels = tags.map{|t| Label.where("name ilike (?)", t).first }
      track_ids = labels.map{|l| l.track_ids}.inject(:&)

      playlist_tracks = playlist_tracks.joins(:track)
        .where("playlist_tracks.track_id in (?)", track_ids)
    end
    if query.present?
      playlist_tracks = playlist_tracks.joins(:track).where("tracks.title ILIKE (?)", "%#{query}%")
    end
    playlist_tracks
  end
end
