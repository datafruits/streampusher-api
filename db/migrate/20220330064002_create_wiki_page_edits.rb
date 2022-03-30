class CreateWikiPageEdits < ActiveRecord::Migration[5.1]
  def change
    create_table :wiki_page_edits do |t|
      t.string :title
      t.text :body
      t.references :user, null: false
      t.references :wiki_page

      t.timestamps
    end
  end
end
