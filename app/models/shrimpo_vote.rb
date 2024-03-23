class ShrimpoVote < ApplicationRecord
  belongs_to :shrimpo_entry
  belongs_to :user

  validates :score, numericality: { in: 1..6 }

  # TODO validate not voting on own entry
  validate :cant_vote_on_own_entry

  private
  def cant_vote_on_own_entry
    if user == shrimpo_entry.user
      self.errors.add(:user, " no votes on own entry!")
    end
  end
end
