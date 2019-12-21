class AddPublishedToBlogPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_posts, :published, :boolean, default: false, null: false
  end
end
