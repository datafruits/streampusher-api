class CreateBlogPostBodies < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_post_bodies do |t|
      t.integer :language, null: false, default: 0
      t.references :blog_post, null: false, index: true
      t.string :title, null: false
      t.text :body

      t.timestamps
    end
  end
end
