class AddNameToSubcription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :name, :string, null: false, default: ""
  end
end
