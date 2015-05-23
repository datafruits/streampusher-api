class AddColorToShow < ActiveRecord::Migration
  def change
    add_column :shows, :color, :string
  end
end
