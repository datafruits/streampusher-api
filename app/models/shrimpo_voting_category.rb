class ShrimpoVotingCategory < ApplicationRecord
  belongs_to :shrimpo
  has_many :shrimpo_votes
  belongs_to :trophy

  validates :name, presence: true
  validates :emoji, presence: true
end
