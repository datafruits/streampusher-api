class MicrotextSerializer < ActiveModel::Serializer
  attributes :content, :id, :username, :avatar_url, :created_at

  def username
    object.user.username
  end

  def avatar_url
    object.user.thumb_image_url
  end
end
