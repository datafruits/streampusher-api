class PlaylistTrack < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :playlist_id

  belongs_to :track
  belongs_to :playlist, touch: true

  before_create :set_podcast_published_date

  default_scope { order(position: :asc) }

  private
  def set_podcast_published_date
    self.podcast_published_date = DateTime.now
  end
end
