class AddSlugToShowSeries < ActiveRecord::Migration[6.1]
  def change
    add_column :show_series, :slug, :string
    add_index :show_series, :slug, unique: true
  end
end
