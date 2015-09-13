class Track < ActiveRecord::Base
  belongs_to :radio
  has_many :playlist_tracks
  has_many :playlists, through: :playlist_tracks
  has_tags column: :file_basename, storage: :s3,
           s3_credentials: { bucket: "streampusher",
                             access_key_id: ENV['S3_KEY'],
                             secret_access_key: ENV['S3_SECRET'] }
  after_save :download

  def file_basename
    File.basename self.audio_file_name.to_s
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
