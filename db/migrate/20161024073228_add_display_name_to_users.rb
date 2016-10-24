class AddDisplayNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :display_name, :string, null: false, default: ""
  end
end
