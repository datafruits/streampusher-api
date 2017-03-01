class AddUserIdToSubscription < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :user_id, :integer, null: false
  end
end
