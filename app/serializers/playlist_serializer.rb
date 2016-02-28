class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :playlist_tracks, embed: :ids, key: :playlist_tracks, embed_in_root: true
end
