class ShrimpoVotingCategory < ApplicationRecord
  validates :name, presence: true
  validates :emoji, presence: true
end
