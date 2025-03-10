class ShrimpoVotingCategory < ApplicationRecord
  belongs_to :shrimpo
  belongs_to :gold_trophy, class_name: "Trophy"
  belongs_to :silver_trophy, class_name: "Trophy"
  belongs_to :bronze_trophy, class_name: "Trophy"
  has_many :shrimpo_voting_category_scores

  validates :name, presence: true
  validates :emoji, presence: true
end
