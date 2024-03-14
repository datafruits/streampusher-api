class ShrimpoEntry < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :shrimpo
  belongs_to :user

  has_many :shrimpo_votes
  has_many :posts, as: :postable

  validates :title, presence: true

  has_one_attached :audio

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
end
