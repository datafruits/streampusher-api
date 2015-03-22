class PlaylistTrack < ActiveRecord::Base
  include RankedModel
  belongs_to :track
  belongs_to :playlist
  ranks :position, with_same: :playlist_id
end
