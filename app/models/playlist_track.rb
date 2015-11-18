class PlaylistTrack < ActiveRecord::Base
  include RankedModel
  belongs_to :track
  belongs_to :playlist, touch: true
  ranks :position, with_same: :playlist_id
  before_create :set_podcast_published_date

  private
  def set_podcast_published_date
    self.podcast_published_date = DateTime.now
  end
end
