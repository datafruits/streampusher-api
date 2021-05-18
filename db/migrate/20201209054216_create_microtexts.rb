class CreateMicrotexts < ActiveRecord::Migration[5.0]
  def change
    create_table :microtexts do |t|
      t.references :user, null: false
      t.references :radio, null: false
      t.string :content, null: false
      t.boolean :approved, null: false, default: false

      t.timestamps
    end
  end
end
