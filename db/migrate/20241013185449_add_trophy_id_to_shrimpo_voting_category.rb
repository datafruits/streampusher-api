class AddTrophyIdToShrimpoVotingCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpo_voting_categories, :trophy_id, :integer, index: true
  end
end
