class PodcastItem < ActiveRecord::Base
  belongs_to :podcast
  belongs_to :track
end
