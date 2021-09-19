class AddGuestToScheduledShows < ActiveRecord::Migration[5.0]
  def change
    add_column :scheduled_shows, :is_guest, :boolean, default: false, null: false
    add_column :scheduled_shows, :guest, :string, default: "", null: false
  end
end
