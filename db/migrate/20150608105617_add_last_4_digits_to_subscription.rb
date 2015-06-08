class AddLast4DigitsToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :last_4_digits, :integer
  end
end
