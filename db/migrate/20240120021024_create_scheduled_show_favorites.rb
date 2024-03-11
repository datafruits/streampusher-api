class CreateScheduledShowFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :scheduled_show_favorites do |t|
      t.references :user, null: false
      t.references :scheduled_show, null: false

      t.timestamps
    end

    add_index :scheduled_show_favorites, [:user_id, :scheduled_show_id], unique: true
  end
end
