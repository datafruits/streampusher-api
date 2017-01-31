class CreateInvoicePayments < ActiveRecord::Migration
  def change
    create_table :invoice_payments do |t|
      t.string :stripe_id, null: false
      t.integer :amount, null: false
      t.integer :fee_amount, null: false
      t.references :user, index: true, foreign_key: true
      t.references :subscription, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
