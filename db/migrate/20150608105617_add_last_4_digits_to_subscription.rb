class AddLast4DigitsToSubscription < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :last_4_digits, :string
  end
end
