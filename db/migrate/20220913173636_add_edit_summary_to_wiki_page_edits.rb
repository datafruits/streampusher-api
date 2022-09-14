class AddEditSummaryToWikiPageEdits < ActiveRecord::Migration[5.2]
  def change
    add_column :wiki_page_edits, :summary, :string
  end
end
