require 'cgi'

class Track < ActiveRecord::Base
  include SoId3::BackgroundJobs
  belongs_to :radio
  belongs_to :uploaded_by, class_name: "User"
  belongs_to :scheduled_show
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks
  has_many :track_labels, dependent: :destroy
  has_many :labels, through: :track_labels
  has_many :track_favorites
  has_many :posts, as: :postable

  has_attached_file :artwork,
    storage: :s3,
    s3_protocol: :https,
    styles: { :thumb => "x300" },
    s3_credentials: { bucket: ENV['S3_BUCKET'],
                      access_key_id: ENV['S3_KEY'],
                      secret_access_key: ENV['S3_SECRET'],
                      s3_region: ENV['S3_REGION'] },
    path: ":attachment/:style/:basename_:timestamp.:extension"

  validates_attachment_content_type :artwork, content_type: /\Aimage\/.*\Z/

  before_post_process :transliterate_file_name

  has_tags column: :s3_filepath, storage: :s3,
           artwork_column: :artwork,
           s3_credentials: { bucket: ENV['S3_BUCKET'],
                             access_key_id: ENV['S3_KEY'],
                             secret_access_key: ENV['S3_SECRET'],
                             region: ENV['S3_REGION'] }

  after_create :sync_tags_in_background

  default_scope { order(updated_at: :desc) }

  accepts_nested_attributes_for :labels

  enum tag_processing_status: ['unprocessed', 'processing', 'done', 'failed']
  enum mixcloud_upload_status: ['mixcloud_not_uploaded', 'mixcloud_uploading', 'mixcloud_upload_complete', 'mixcloud_upload_failed']
  enum soundcloud_upload_status: ['soundcloud_not_uploaded', 'soundcloud_uploading', 'soundcloud_upload_complete', 'soundcloud_upload_failed']

  before_save :set_tags_from_scheduled_show
  after_commit :sync_tags_in_background, on: :update, if: :saved_change_to_audio_file_name?

  def url
    if ::Rails.env.production?
      return cdn_url
    else
      return s3_filepath
    end
  end

  def s3_filepath
    file_name = CGI.unescape(self.audio_file_name)
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
    File.basename CGI.unescape(self.audio_file_name.to_s)
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

  def formatted_duration
    if self.length
      minutes = (self.length / 60) % 60
      seconds = self.length % 60
      hours = self.length / (60 * 60)
      format("%02d:%02d:%02d", hours, minutes, seconds)
    end
  end

  def thumb_artwork_url
    self.artwork.url(:thumb)
  end

  private
  def set_tags_from_scheduled_show
    if self.scheduled_show.present?
      if self.title.blank?
        self.title = "#{self.scheduled_show.title} - #{self.scheduled_show.start_at.strftime("%m%d%Y")}"
      end
      unless self.artwork.present?
        if self.scheduled_show.image.present?
          self.artwork = self.scheduled_show.image
        elsif self.scheduled_show.dj.image.present?
          self.artwork = self.scheduled_show.dj.image
        end
      end
    end
  end

  def transliterate_file_name
    base = "#{self.artist}_#{self.title}_#{self.album}"
    mime = self.artwork.content_type
    ext = Rack::Mime::MIME_TYPES.invert[mime]

    new_file_name = "#{base.parameterize}_#{Digest::SHA256.hexdigest(base)}#{ext}"
    self.artwork.instance_write(:file_name, new_file_name)
  end
end
