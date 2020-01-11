class RemoveSubscriptions < ActiveRecord::Migration[5.0]
  def change
    drop_table :invoice_payments
    drop_table :stripe_webhooks
    drop_table :subscriptions
    remove_column :radios, :subscription_id
  end
end
