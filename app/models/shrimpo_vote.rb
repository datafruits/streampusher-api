class ShrimpoVote < ApplicationRecord
  belongs_to :shrimpo_entry
  belongs_to :user
  belongs_to :shrimpo_voting_category

  validates :score, numericality: { in: 1..6 }

  validate :cant_vote_on_own_entry

  # TODO validate that shrimpo is in voting status
  #
  after_create :give_xp

  private
  def give_xp
    ExperiencePointAward.create! user: self.user, source: self, award_type: :shrimpo_appreciator, amount: 1
  end

  def cant_vote_on_own_entry
    if user == shrimpo_entry.user
      self.errors.add(:user, " no votes on own entry!")
    end
  end
end
