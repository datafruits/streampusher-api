class AddTotalScoreAndRankingToShrimpoEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpo_entries, :total_score, :integer
    add_column :shrimpo_entries, :ranking, :integer
  end
end
