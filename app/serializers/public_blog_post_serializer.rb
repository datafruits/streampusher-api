class PublicBlogPostSerializer < ActiveModel::Serializer
  attributes :id
  has_many :blog_post_bodies, embed: :ids, key: :blog_post_bodies, embed_in_root: true

  def blog_post_bodies
    object.blog_post_bodies.published
  end
end
