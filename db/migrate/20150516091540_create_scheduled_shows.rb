class CreateScheduledShows < ActiveRecord::Migration
  def change
    create_table :scheduled_shows do |t|
      t.references :show, null: false
      t.references :radio, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps
    end
  end
end
