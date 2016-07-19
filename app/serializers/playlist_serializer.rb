class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name, :interpolated_playlist_enabled,
    :interpolated_playlist_track_interval_count,
    :interpolated_playlist_track_play_count, :interpolated_playlist_id,
    :updated_at
  has_many :playlist_tracks, embed: :ids, key: :playlist_tracks, embed_in_root: true
end
