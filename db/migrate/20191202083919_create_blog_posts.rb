class CreateBlogPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_posts do |t|
      t.references :user, null: false, index: true
      t.references :radio, null: false, index: true

      t.timestamps
    end
  end
end
