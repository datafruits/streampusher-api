class CreateFruits < ActiveRecord::Migration[5.0]
  def change
    create_table :fruits do |t|
      t.integer :cost, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
