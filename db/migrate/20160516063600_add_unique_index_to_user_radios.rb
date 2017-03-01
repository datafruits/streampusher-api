class AddUniqueIndexToUserRadios < ActiveRecord::Migration[4.2]
  def change
    add_index :user_radios, [:user_id, :radio_id], unique: true
  end
end
