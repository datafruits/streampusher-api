class ShrimpoVotingCategorySerializer < ActiveModel::Serializer
  attributes :name, :emoji
  has_many :shrimpo_voting_category_scores, embed: :ids, key: :shrimpo_voting_category_scores, embed_in_root: true, each_serializer: ShrimpoVotingCategoryScoreSerializer

  def shrimpo_voting_category_scores
    object.shrimpo_voting_category_scores
  end
end
