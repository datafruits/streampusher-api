class Recording < ActiveRecord::Base
  belongs_to :radio
  belongs_to :dj, class_name: "User"
  belongs_to :show
  has_attached_file :file

  validates_attachment :file, presence: true,
    content_type: { content_type: [ "audio/mpeg", "audio/mp3"] }

end
