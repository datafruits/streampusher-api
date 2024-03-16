class ShrimpoEntry < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :shrimpo
  belongs_to :user

  has_many :shrimpo_votes
  has_many :posts, as: :postable

  validates :title, presence: true

  has_one_attached :audio

  after_create :send_notification

  def previous_entry
    previous, nextious = self.shrimpo.sorted_entries.split(self)
    if previous.any?
      return previous.last
    end
  end

  def next_entry
    previous, nextious = self.shrimpo.sorted_entries.split(self)
    if nextious.any?
      return nextious.first
    end
  end

  def username
    self.user.username
  end

  def slug_candidates
    [
      [:title, :username],
      [:title, :username, :id],
    ]
  end

  private
  def send_notification
    Notification.create! notification_type: 'shrimpo_entry', source: self, user: self.user, send_to_chat: true, send_to_user: false
  end
end
