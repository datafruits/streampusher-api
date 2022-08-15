class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name, :interpolated_playlist_enabled,
    :interpolated_playlist_track_interval_count,
    :interpolated_playlist_track_play_count, :interpolated_playlist_id,
    :no_cue_out, :updated_at, :shuffle, :created_by
  has_many :playlist_tracks, embed: :ids, key: :playlist_tracks, embed_in_root: true, each_serializer: PlaylistTrackSerializer

  def created_by
    object.user.try(:username)
  end

  def playlist_tracks
    object.playlist_tracks.page(scope[:playlist_tracks][:page])
  end

  def meta
    {
      page: scope[:playlist_tracks][:page],
      total_pages: playlist_tracks.page.total_pages.to_i
    }
  end
end
