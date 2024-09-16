class CreateShrimpoEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :shrimpo_entries do |t|
      t.references :shrimpo, null: false, index: true
      t.references :user, null: false, index: true

      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
