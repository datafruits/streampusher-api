class AddStripeToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :stripe_customer_token, :string
  end
end
