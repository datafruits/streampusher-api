class CreateTrackListingItem < ActiveRecord::Migration[5.0]
  def change
    create_table :track_listing_items do |t|
      t.references :track_listing, null: false
      t.string :title
      t.string :artist
      t.string :link

      t.timestamps null: false
    end
  end
end
