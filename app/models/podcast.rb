class Podcast < ActiveRecord::Base
  belongs_to :radio
  has_one :playlist
end
