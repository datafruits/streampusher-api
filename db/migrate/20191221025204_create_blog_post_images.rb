class CreateBlogPostImages < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_post_images do |t|
      t.references :blog_post_body, foreign_key: true
      t.string :image_file_name
      t.integer :filesize

      t.timestamps
    end
  end
end
