class AddSlugToShrimpos < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpos, :slug, :string
    add_index :shrimpos, :slug, unique: true
  end
end
