class AddUserIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :user_id, :integer, null: false
  end
end
