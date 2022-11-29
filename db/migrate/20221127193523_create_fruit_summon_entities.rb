class CreateFruitSummonEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :fruit_summon_entities do |t|
      t.string :name
      t.integer :cost
    end
  end
end
