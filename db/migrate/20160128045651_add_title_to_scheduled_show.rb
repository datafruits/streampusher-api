class AddTitleToScheduledShow < ActiveRecord::Migration[4.2]
  def change
    add_column :scheduled_shows, :title, :string
  end
end
