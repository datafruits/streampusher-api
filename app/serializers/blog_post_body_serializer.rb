class BlogPostBodySerializer < ActiveModel::Serializer
  attributes :id, :body, :title, :language, :published, :published_at
  has_many :blog_post_images, embed: :ids, key: :blog_post_images, embed_in_root: true
end
