class AddDeletedAtToWikiPages < ActiveRecord::Migration[5.2]
  def change
    add_column :wiki_pages, :deleted_at, :datetime
  end
end
