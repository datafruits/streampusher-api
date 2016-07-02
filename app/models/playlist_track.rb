class PlaylistTrack < ActiveRecord::Base
  # include RankedModel
  # ranks :position, with_same: :playlist_id

  belongs_to :track
  belongs_to :playlist, touch: true
  acts_as_list scope: :playlist, top_of_list: 0, add_new_at: :top

  before_create :set_podcast_published_date

  # default_scope { order(position: :desc) }

  private
  def set_podcast_published_date
    self.podcast_published_date = DateTime.now
  end
end
