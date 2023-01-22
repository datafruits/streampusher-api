class CreateFruitSummons < ActiveRecord::Migration[5.2]
  def change
    create_table :fruit_summons do |t|
      t.references :fruit_ticket_transaction, null: false, index: true
      t.references :user, null: false, index: true
      t.references :fruit_summon_entity, null: false, index: true

      t.timestamps
    end
  end
end
