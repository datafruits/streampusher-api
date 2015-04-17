class Podcast < ActiveRecord::Base
  belongs_to :radio
  has_many :podcast_items
end
