class AddSlugToWikiPages < ActiveRecord::Migration[5.2]
  def change
    add_column :wiki_pages, :slug, :string
    add_index :wiki_pages, :slug, unique: true
  end
end
