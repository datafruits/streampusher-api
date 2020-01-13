class MovePublishedToBlogPostBodies < ActiveRecord::Migration[5.0]
  def change
    remove_column :blog_posts, :published
    add_column :blog_post_bodies, :published, :boolean, default: false, null: false
  end
end
