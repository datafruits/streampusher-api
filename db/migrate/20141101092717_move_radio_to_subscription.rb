class MoveRadioToSubscription < ActiveRecord::Migration[4.2]
  def change
    remove_column :radios, :user_id, null: false
    add_column :radios, :subscription_id, :integer, null: false
  end
end
