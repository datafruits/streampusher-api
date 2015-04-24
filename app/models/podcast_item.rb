class PodcastItem < ActiveRecord::Base
  include RankedModel
  belongs_to :podcast
  belongs_to :track
  ranks :position, with_same: :podcast_id
end
