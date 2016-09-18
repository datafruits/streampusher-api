class PlaylistTrack < ActiveRecord::Base
  belongs_to :track
  belongs_to :playlist, touch: true
  acts_as_list scope: :playlist, top_of_list: 0, add_new_at: :top

  before_create :set_podcast_published_date

  private
  def set_podcast_published_date
    self.podcast_published_date = DateTime.now
  end
end
