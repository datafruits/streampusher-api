class ShrimpoVotingCategory < ApplicationRecord
  belongs_to :shrimpo
  has_many :shrimpo_votes
  belongs_to :gold_trophy, class_name: "Trophy"
  belongs_to :silver_trophy, class_name: "Trophy"
  belongs_to :bronze_trophy, class_name: "Trophy"

  validates :name, presence: true
  validates :emoji, presence: true
end
