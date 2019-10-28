class AddProfilePublishToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_publish, :boolean, default: false, null: false
  end
end
