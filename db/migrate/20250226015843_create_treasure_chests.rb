class CreateTreasureChests < ActiveRecord::Migration[7.0]
  def change
    create_table :treasure_chests do |t|
      t.string :treasure_name
      t.integer :amount
      t.references :user
      t.string :treasure_uid

      t.timestamps
    end
  end
end
