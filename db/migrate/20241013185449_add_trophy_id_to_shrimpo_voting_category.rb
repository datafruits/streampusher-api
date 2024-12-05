class AddTrophyIdToShrimpoVotingCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpo_voting_categories, :gold_trophy_id, :integer, index: true
    add_column :shrimpo_voting_categories, :silver_trophy_id, :integer, index: true
    add_column :shrimpo_voting_categories, :bronze_trophy_id, :integer, index: true
  end
end
