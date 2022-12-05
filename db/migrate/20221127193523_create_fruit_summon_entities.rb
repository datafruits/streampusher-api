class CreateFruitSummonEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :fruit_summon_entities do |t|
      t.string :name, null: false
      t.integer :cost, null: false

      t.timestamps
    end
  end
end
