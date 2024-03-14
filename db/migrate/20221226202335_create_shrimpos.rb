class CreateShrimpos < ActiveRecord::Migration[6.1]
  def change
    create_table :shrimpos do |t|
      t.references :user, null: false, index: true
      t.string :title, null: false

      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.text :rule_pack

      t.timestamps
    end
  end
end
