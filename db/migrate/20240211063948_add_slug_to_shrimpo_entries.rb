class AddSlugToShrimpoEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :shrimpo_entries, :slug, :string
    add_index :shrimpo_entries, :slug, unique: true
  end
end
