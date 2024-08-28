class ShrimpoVoteSerializer < ActiveModel::Serializer
  attributes :score
  belongs_to :user
  belongs_to :shrimpo_entry
  belongs_to :shrimpo_voting_category
end
