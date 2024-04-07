class AddShrimpoVoteUniqueIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :shrimpo_votes, [:user_id, :shrimpo_entry_id], unique: true
  end
end
