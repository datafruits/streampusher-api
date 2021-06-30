class CreatePatreons < ActiveRecord::Migration[5.0]
  def change
    create_table :patreons do |t|
      t.integer :patreon_id, null: false
      t.string :full_name, null: false
      t.integer :amount_cents, null: false
      t.references :user

      t.timestamps
    end

    add_index :patreons, [:full_name, :id], unique: true
    add_index :patreons, [:patreon_id, :id], unique: true
  end
end
