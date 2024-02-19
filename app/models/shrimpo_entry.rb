class ShrimpoEntry < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :shrimpo
  belongs_to :user

  has_many :shrimpo_votes

  validates :title, presence: true

  has_one_attached :audio

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
