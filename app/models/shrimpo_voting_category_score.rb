class ShrimpoVotingCategoryScore < ApplicationRecord
  belongs_to :shrimpo
  belongs_to :shrimpo_entry
  belongs_to :shrimpo_voting_category # for MEGA shrimpo
end
