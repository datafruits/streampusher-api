class ShrimpoVotingCategoryScoreSerializer < ActiveModel::Serializer
  belongs_to :shrimpo_voting_category
  belongs_to :shrimpo_entry
  attributes :score, :ranking
end
