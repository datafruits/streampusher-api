class AddColorToShow < ActiveRecord::Migration[4.2]
  def change
    add_column :shows, :color, :string
  end
end
