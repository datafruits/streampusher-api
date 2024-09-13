class ShrimpoVoteSerializer < ActiveModel::Serializer
  attributes :score, :voting_category_name, :voting_category_emoji
  belongs_to :user
  belongs_to :shrimpo_entry
  belongs_to :shrimpo_voting_category

  def voting_category_name
    object.shrimpo_voting_category.name
  end

  def voting_category_emoji
    object.shrimpo_voting_category.emoji
  end
end
