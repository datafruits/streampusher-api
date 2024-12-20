class AddShrimpoIdToShrimpoVotingCategoryScore < ActiveRecord::Migration[7.0]
  def change
    add_reference :shrimpo_voting_category_scores, :shrimpo
  end
end
