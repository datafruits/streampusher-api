class Track < ActiveRecord::Base
  belongs_to :radio
  has_many :playlist_tracks
  has_many :playlists, through: :playlist_tracks

  def file_basename
    File.basename self.audio_file_name
  end
end
