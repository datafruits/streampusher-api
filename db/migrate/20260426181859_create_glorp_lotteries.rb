class CreateGlorpLotteries < ActiveRecord::Migration[7.0]
  def change
    create_table :glorp_lotteries do |t|
      t.references :user, index: true, null: false
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
