class Podcast < ActiveRecord::Base
  belongs_to :radio
  belongs_to :playlist
  serialize :extra_tags, Hash

  has_attached_file :image,
    styles: { medium: "300x300>", thumb: "100x100>" },
    path: ":attachment/:style/:basename.:extension"

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
