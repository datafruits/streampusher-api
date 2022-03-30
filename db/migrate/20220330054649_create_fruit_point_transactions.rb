class CreateFruitPointTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :fruit_point_transactions do |t|
      t.references :user, null: false, index: true
      t.integer :transaction_type, null: false
      t.integer :amount, null: false, default: 0
      t.integer :source_id

      t.timestamps
    end
  end
end
