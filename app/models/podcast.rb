class Podcast < ActiveRecord::Base
  belongs_to :radio
  belongs_to :playlist
end
