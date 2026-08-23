class CreateTrackListing < ActiveRecord::Migration[5.0]
  def change
    create_table :track_listings do |t|
      t.references :track, null: false

      t.timestamps null: false
    end
  end
end
