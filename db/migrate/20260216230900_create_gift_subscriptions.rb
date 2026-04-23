class CreateGiftSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_subscriptions do |t|
      t.integer :gifter_id, null: false
      t.integer :giftee_id
      t.string :stripe_payment_intent_id
      t.decimal :amount, precision: 8, scale: 2, null: false, default: 7.00
      t.integer :status, default: 0, null: false
      t.datetime :expires_at
      t.datetime :activated_at
      t.text :message

      t.timestamps
    end

    add_index :gift_subscriptions, :gifter_id
    add_index :gift_subscriptions, :giftee_id
    add_index :gift_subscriptions, :stripe_payment_intent_id
    add_index :gift_subscriptions, :status
    add_index :gift_subscriptions, :expires_at
  end
end
