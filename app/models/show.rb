class Show < ActiveRecord::Base
  belongs_to :radio
  belongs_to :dj, class_name: "User"
  has_many :scheduled_shows
  belongs_to :playlist
  validates_presence_of :playlist_id
end
