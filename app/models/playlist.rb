class Playlist < ActiveRecord::Base
  belongs_to :radio
  has_many :playlist_tracks
  has_many :tracks, through: :playlist_tracks

  def redis_key
    "#{self.radio.name}:playlist"
  end

  def add_track track
    self.tracks << track
  end

  def remove_track playlist_track
    playlist_track.destroy
  end
end
