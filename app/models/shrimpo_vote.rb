class ShrimpoVote < ApplicationRecord
  belongs_to :shrimpo_entry
  belongs_to :user

  validates :score, numericality: { in: 1..6 }
end
