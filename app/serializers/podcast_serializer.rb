class PodcastSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :tracks, embed: :ids, key: :tracks, embed_in_root: true, each_serializer: PlaylistTrackSerializer

  def tracks
    playlist_tracks = object.playlist.playlist_tracks
      .unscoped
      .where(playlist_id: object.playlist.id)
      .order("podcast_published_date DESC")
      .page(scope[:tracks][:page])

    playlist_tracks
  end
end
