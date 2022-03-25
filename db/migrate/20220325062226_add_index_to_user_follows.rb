class AddIndexToUserFollows < ActiveRecord::Migration[5.1]
  def change
    add_index :user_follows, [:user_id, :followee_id], unique: true
  end
end
