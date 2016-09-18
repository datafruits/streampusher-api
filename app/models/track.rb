class Track < ActiveRecord::Base
  include SoId3::BackgroundJobs
  belongs_to :radio
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks
  has_many :track_labels, dependent: :destroy
  has_many :labels, through: :track_labels

  has_attached_file :artwork,
    storage: :s3,
    styles: { :thumb => "x300" },
    s3_credentials: { bucket: ENV['S3_BUCKET'],
                      access_key_id: ENV['S3_KEY'],
                      secret_access_key: ENV['S3_SECRET'] },
    path: ":attachment/:style/:basename.:extension"

  validates_attachment_content_type :artwork, content_type: /\Aimage\/.*\Z/

  has_tags column: :s3_filepath, storage: :s3,
           artwork_column: :artwork,
           s3_credentials: { bucket: ENV['S3_BUCKET'],
                             access_key_id: ENV['S3_KEY'],
                             secret_access_key: ENV['S3_SECRET'] }
  after_tags_synced :download # will this happen before the update tags job finishes? :(

  default_scope { order(updated_at: :desc) }

  accepts_nested_attributes_for :labels

  enum tag_processing_status: ['unprocessed', 'processing', 'done', 'failed']
  enum mixcloud_upload_status: ['mixcloud_not_uploaded', 'mixcloud_uploading', 'mixcloud_upload_complete', 'mixcloud_upload_failed']

  def s3_filepath
    split = URI.decode(self.audio_file_name).split("#{ENV["S3_BUCKET"]}")
    if split.first =~ /s3.amazonaws.com/
      return split.last[1..-1]
    else
      return split.last.split(".s3.amazonaws.com").last[1..-1]
    end
  end

  def cloudfront_url
    "https://#{ENV['CLOUDFRONT_URL']}/#{s3_filepath}"
  end

  def file_basename
    File.basename URI.decode(self.audio_file_name.to_s)
  end

  def local_path
    "#{local_directory}/#{file_basename}"
  end

  def local_directory
    self.radio.tracks_directory
  end

  def display_name
    if self.artist.present?
      "#{self.artist} - #{self.title}"
    elsif self.title.present?
      "#{self.title}"
    else
      self.file_basename.to_s
    end
  end

  def download
    DownloadTrackWorker.perform_later self.id
  end
end
