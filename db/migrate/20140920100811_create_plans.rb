class CreatePlans < ActiveRecord::Migration[4.2]
  def change
    create_table :plans do |t|
      t.decimal :price

      t.timestamps
    end
  end
end
