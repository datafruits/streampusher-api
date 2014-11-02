class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :title, null: false, default: ''
      t.integer :dj_id, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.text :description, null: false, default: ''

      t.timestamps
    end
  end
end
