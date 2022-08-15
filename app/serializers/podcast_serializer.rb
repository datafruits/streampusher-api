class PodcastSerializer < ActiveModel::Serializer
  attributes :id, :name, :meta
  has_many :tracks, embed: :ids, key: :tracks, embed_in_root: true, each_serializer: TrackSerializer

  def tracks
    playlist_tracks = object.playlist.playlist_tracks
      .unscoped
      .where(playlist_id: object.playlist.id)
      .order("podcast_published_date DESC")

    if scope[:tracks][:query] || scope[:tracks][:tags]
      playlist_tracks = PlaylistTracksSearch.perform playlist_tracks, scope[:tracks][:query], scope[:tracks][:tags]
    end

    Track.where(id: playlist_tracks.pluck(:track_id)).page(scope[:tracks][:page])
  end

  def meta
    {
      page: scope[:tracks][:page],
      total_pages: tracks.page.total_pages.to_i
    }
  end
end
