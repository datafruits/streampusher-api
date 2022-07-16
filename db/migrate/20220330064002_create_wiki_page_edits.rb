class CreateWikiPageEdits < ActiveRecord::Migration[5.1]
  def change
    create_table :wiki_page_edits do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :user, null: false
      t.references :wiki_page

      t.timestamps
    end
  end
end
