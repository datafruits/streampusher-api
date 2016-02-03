class AddTitleToScheduledShow < ActiveRecord::Migration
  def change
    add_column :scheduled_shows, :title, :string
  end
end
