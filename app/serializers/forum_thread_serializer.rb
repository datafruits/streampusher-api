class ForumThreadSerializer < ActiveModel::Serializer
  attributes :id, :title, :poster_username, :poster_avatar, :posts, :created_at
  has_many :posts, embed: :ids, key: :posts, embed_in_root: true, each_serializer: PostSerializer

  def posts
    object.posts
  end

  def poster_username
    unless object.posts.empty?
      object.posts.first.user.username
    end
  end

  def poster_avatar
    unless object.posts.empty?
      object.posts.first.user.image.url(:thumb)
    end
  end
end
