class PlaylistTrack < ActiveRecord::Base
  belongs_to :track
  belongs_to :playlist, touch: true
  acts_as_list scope: :playlist, top_of_list: 0, add_new_at: :top

  before_create :set_podcast_published_date
  after_save :maybe_give_xp

  private
  def set_podcast_published_date
    self.podcast_published_date = DateTime.now
  end

  def maybe_give_xp
    if (self.playlist.id == self.track.radio.default_playlist_id) && self.track.uploaded_by.present?
      amount = 20
      if self.track.artwork.present?
        amount += 15
      end
      if self.track.scheduled_show.present?
        amount += 15
      end
      if self.track.title.present?
        amount += 10
      end
      if self.track.labels.count > 0
        amount += 5
        if self.track.labels.count >= 3
          amount += 10
        end
      end
      ExperiencePointAward.create! user: self.track.uploaded_by, source: self, amount: amount, award_type: :uploaderzog
    end
  end
end
