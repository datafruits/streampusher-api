class CreateFruitTips < ActiveRecord::Migration[5.0]
  def change
    create_table :fruit_tips do |t|
      t.integer :amount, null: false
      t.references :from, index: true, foreign_key: {to_table: :users}, null: false
      t.string :to, null: false
      t.references :fruit, null: false, foreign_key: true, null: false
      t.references :user, null: false, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
