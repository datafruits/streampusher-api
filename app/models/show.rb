class Show < ActiveRecord::Base
  belongs_to :radio
  belongs_to :dj, class_name: "User"
  has_many :scheduled_shows
  belongs_to :playlist
  has_attached_file :image, styles: { :thumb => "x120" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_validation :set_default_playlist

  validates_presence_of :playlist_id

  # validates :color, unique: true, scope: radio_id

  def self.colors
  end

  def set_default_playlist
    unless self.playlist.present?
      self.playlist_id = self.radio.playlists.first.try(:id)
    end
  end
end
