class MoveRadioToSubscription < ActiveRecord::Migration
  def change
    remove_column :radios, :user_id, null: false
    add_column :radios, :subscription_id, :integer, null: false
  end
end
