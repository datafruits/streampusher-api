class TrackFavorite < ActiveRecord::Base
  belongs_to :track
  belongs_to :user
end
