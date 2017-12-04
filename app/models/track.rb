class Track < ActiveRecord::Base
  include SoId3::BackgroundJobs
  belongs_to :radio
  belongs_to :uploaded_by, class: "User"
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks
  has_many :track_labels, dependent: :destroy
  has_many :labels, through: :track_labels
  has_attached_file :artwork,
    storage: :s3,
    s3_protocol: :https,
    styles: { :thumb => "x300" },
    s3_credentials: { bucket: ENV['S3_BUCKET'],
                      access_key_id: ENV['S3_KEY'],
                      secret_access_key: ENV['S3_SECRET'],
                      s3_region: ENV['S3_REGION'] },
    path: ":attachment/:style/:basename.:extension"

  validates_attachment_content_type :artwork, content_type: /\Aimage\/.*\Z/

  before_post_process :transliterate_file_name

  has_tags column: :s3_filepath, storage: :s3,
           artwork_column: :artwork,
           s3_credentials: { bucket: ENV['S3_BUCKET'],
                             access_key_id: ENV['S3_KEY'],
                             secret_access_key: ENV['S3_SECRET'],
                             region: ENV['S3_REGION'] }

  default_scope { order(updated_at: :desc) }

  accepts_nested_attributes_for :labels

  enum tag_processing_status: ['unprocessed', 'processing', 'done', 'failed']
  enum mixcloud_upload_status: ['mixcloud_not_uploaded', 'mixcloud_uploading', 'mixcloud_upload_complete', 'mixcloud_upload_failed']

  def s3_filepath
    file_name = URI.decode(self.audio_file_name)
    if file_name.include?(ENV["S3_BUCKET"])
      split = file_name.split(ENV["S3_BUCKET"])
      if split.first =~ /s3.amazonaws.com/
        return split.last[1..-1]
      else
        return split.last.split(".s3.amazonaws.com").last[1..-1]
      end
    else
      return file_name
    end
  end

  def cdn_url
    "https://#{ENV['CLOUDFRONT_URL']}/#{s3_filepath}?#{self.updated_at.to_i}"
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

  private
  def transliterate_file_name
    base = "#{self.artist}_#{self.title}_#{self.album}"
    mime = self.artwork.content_type
    ext = Rack::Mime::MIME_TYPES.invert[mime]

    new_file_name = "#{base.parameterize}_#{Digest::SHA256.hexdigest(base)}#{ext}"
    self.artwork.instance_write(:file_name, new_file_name)
  end
end
