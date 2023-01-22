class PostSerializer < ActiveModel::Serializer
  attributes :id, :body, :poster_avatar, :poster_username, :poster_role, :created_at
  belongs_to :user

  def poster_username
    object.user.username
  end

  def poster_avatar
    object.user.image.url(:thumb)
  end

  def poster_role
    object.user.role
  end
end
