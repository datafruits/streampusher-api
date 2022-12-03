class CreateFruitTicketTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :fruit_ticket_transactions do |t|
      t.integer :transaction_type, null: false
      t.integer :source_id

      t.integer :amount, null: false, default: 0
      t.integer :from_user_id
      t.integer :to_user_id

      t.timestamps
    end
  end
end
