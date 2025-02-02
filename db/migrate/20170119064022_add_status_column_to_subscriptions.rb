class AddStatusColumnToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :status, :integer, null: false, default: 0
    remove_column :subscriptions, :canceled, :boolean
    remove_column :subscriptions, :on_trial, :boolean
  end
end
