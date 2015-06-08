class AddLast4DigitsToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :last_4_digits, :string
  end
end
