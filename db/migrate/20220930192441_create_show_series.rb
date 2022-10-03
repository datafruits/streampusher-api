class CreateShowSeries < ActiveRecord::Migration[5.2]
  def change
    create_table :show_series do |t|
      t.string :title, null: false
      t.text :description
      t.attachment :image

      t.timestamps null: false
    end

    create_table :show_series_hosts do |t|
      t.references :user, foreign_key: true
      t.references :show_series, foreign_key: true

      t.timestamps null: false
    end
    add_index :show_series_hosts, [:show_series_id, :user_id], unique: true

    create_table :show_series_labels do |t|
      t.references :label, foreign_key: true
      t.references :show_series, foreign_key: true

      t.timestamps null: false
    end
    add_index :show_series_labels, [:show_series_id, :label_id], unique: true

    add_column :scheduled_shows, :show_series_id, :integer
  end
end
