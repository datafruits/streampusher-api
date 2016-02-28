class PlaylistSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name
  has_many :playlist_tracks
end
