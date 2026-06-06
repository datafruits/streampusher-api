class AddStreamKeysToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stream_key, :string
    add_column :users, :stream_key_digest, :string
  end
end
