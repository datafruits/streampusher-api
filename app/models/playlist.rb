class Playlist < ActiveRecord::Base
  belongs_to :radio
  has_many :playlist_tracks
  has_many :tracks, through: :playlist_tracks
end
