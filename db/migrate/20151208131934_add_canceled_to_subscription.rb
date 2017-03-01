class AddCanceledToSubscription < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :canceled, :boolean, default: false, null: false
  end
end
