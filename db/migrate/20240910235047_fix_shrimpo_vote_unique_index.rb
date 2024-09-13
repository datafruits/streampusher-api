class FixShrimpoVoteUniqueIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :shrimpo_votes, [:user_id, :shrimpo_entry_id]
    add_index :shrimpo_votes, [:user_id, :shrimpo_entry_id, :shrimpo_voting_category_id], unique: true, name: "index_shrimpo_votes_uid_seid_svcid"
  end
end
