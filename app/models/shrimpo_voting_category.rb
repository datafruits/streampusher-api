class ShrimpoVotingCategory < ApplicationRecord
  belongs_to :shrimpo
  has_many :shrimpo_votes

  validates :name, presence: true
  validates :emoji, presence: true
end
