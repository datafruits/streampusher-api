class Track < ActiveRecord::Base
  belongs_to :radio
  has_many :playlist_tracks
  has_many :playlists, through: :playlist_tracks
  after_save :download

  def file_basename
    File.basename self.audio_file_name
  end

  def local_path
    "#{local_directory}/#{file_basename}"
  end

  def local_directory
    self.radio.tracks_directory
  end

  def download
    DownloadTrackWorker.perform_later self.id
  end
end
