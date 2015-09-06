class Playlist < ActiveRecord::Base
  belongs_to :radio
  has_many :playlist_tracks, -> { order("podcast_published_date" => "DESC") }
  has_many :tracks, through: :playlist_tracks

  def redis_key
    "#{self.radio.name}:playlist:#{name}"
  end

  def add_track track
    self.tracks << track
  end

  def remove_track playlist_track
    playlist_track.destroy
  end
end
