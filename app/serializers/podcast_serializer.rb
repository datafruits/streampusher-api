class PodcastSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :tracks, serializer: PlaylistTrackSerializer

  def tracks
    object.playlist.playlist_tracks.order("podcast_published_date DESC")
  end
end
