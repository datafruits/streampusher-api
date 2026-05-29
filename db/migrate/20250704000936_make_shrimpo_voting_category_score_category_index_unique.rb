class MakeShrimpoVotingCategoryScoreCategoryIndexUnique < ActiveRecord::Migration[7.0]
  def change
    remove_index :shrimpo_voting_category_scores, name: 'voting_cat_score'
    add_index :shrimpo_voting_category_scores, [:shrimpo_voting_category_id, :shrimpo_entry_id], unique: true, name: 'voting_cat_score'
  end
end
