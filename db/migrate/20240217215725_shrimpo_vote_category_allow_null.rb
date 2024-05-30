class ShrimpoVoteCategoryAllowNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :shrimpo_votes, :shrimpo_voting_category_id, true
  end
end
