class CreateScheduledShowLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :scheduled_show_labels do |t|
      t.references :label, foreign_key: true
      t.references :scheduled_show, foreign_key: true

      t.timestamps null: false
    end
    add_index :scheduled_show_labels, [:scheduled_show_id, :label_id], unique: true
  end
end
