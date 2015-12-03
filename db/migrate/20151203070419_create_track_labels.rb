class CreateTrackLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    create_table :track_labels do |t|
      t.references :label, null: false
      t.references :track, null: false

      t.timestamps null: false
    end
  end
end
