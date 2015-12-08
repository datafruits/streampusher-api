class AddCanceledToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :canceled, :boolean, default: false, null: false
  end
end
