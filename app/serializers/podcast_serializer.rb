class PodcastSerializer < ActiveModel::Serializer
  attributes :id, :name, :tracks

  def tracks
    object.playlist.playlist_tracks
      .unscoped
      .where(playlist_id: object.playlist.id)
      .order("podcast_published_date DESC").map do |playlist_track|
      PlaylistTrackSerializer.new(playlist_track, root: false)
    end
  end
end
