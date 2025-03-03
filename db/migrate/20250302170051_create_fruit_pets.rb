class CreateFruitPets < ActiveRecord::Migration[7.0]
  def change
    create_table :fruit_pets do |t|
      t.references :fruit_species
      t.references :user
      t.integer :level
      t.integer :experience_points
      t.integer :hunger_level
      t.string :name

      t.timestamps
    end

    create_table :fruit_species do |t|
      t.name :string

      t.timestamps
    end
  end
end
