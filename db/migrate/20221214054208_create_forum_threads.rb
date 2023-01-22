class CreateForumThreads < ActiveRecord::Migration[6.1]
  def change
    create_table :forum_threads do |t|
      t.string :title, null: false

      t.timestamps
    end
  end
end
