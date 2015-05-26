class Podcast < ActiveRecord::Base
  belongs_to :radio
  belongs_to :playlist

  has_attached_file :image,
    styles: { medium: "300x300>", thumb: "100x100>" },
    storage: :s3,
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET']
    },
    bucket: "streampusher"

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
