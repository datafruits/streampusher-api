class CreateTrackFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :track_favorites do |t|
      t.references :user, null: false
      t.references :track, null: false

      t.timestamps
    end

    add_index :track_favorites, [:user_id, :track_id], unique: true
  end
end
