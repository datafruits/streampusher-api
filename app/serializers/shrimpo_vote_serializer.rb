class ShrimpoVoteSerializer < ActiveModel::Serializer
  attributes :score, :voting_category_name
  belongs_to :user
  belongs_to :shrimpo_entry
  belongs_to :shrimpo_voting_category

  def voting_category_name
    object.shrimpo_voting_category.name
  end
end
