class BlogPostSerializer < ActiveModel::Serializer
  attributes :id
  has_many :blog_post_bodies, embed: :ids, key: :blog_post_bodies, embed_in_root: true
end
