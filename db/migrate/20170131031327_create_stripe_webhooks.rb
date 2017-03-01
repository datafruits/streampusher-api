class CreateStripeWebhooks < ActiveRecord::Migration[4.2]
  def change
    create_table :stripe_webhooks do |t|
      t.string :stripe_id, null: false

      t.timestamps null: false
    end

    add_index :stripe_webhooks, :stripe_id, unique: true
  end
end
