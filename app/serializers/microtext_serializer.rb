class MicrotextSerializer < ActiveModel::Serializer
  attributes :content, :id, :username, :avatar_url

  def username
    object.user.username
  end

  def avatar_url
    if object.user.image.present?
      object.user.image.url(:thumb)
    end
  end
end
