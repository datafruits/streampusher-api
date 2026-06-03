class RemoveStreamKeyDigestAndAddIndexToStreamKey < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :stream_key_digest, :string
    add_index :users, :stream_key
  end
end
