class DjSerializer < ActiveModel::Serializer
  attributes :id, :username, :image_url, :bio, :image, :style,
    :image_thumb_url, :image_medium_url, :profile_publish

  def image_url
    if object.image.present?
      object.image.url
    end
  end

  def image_thumb_url
    if object.image.present?
      object.image.url(:thumb)
    end
  end

  def image_medium_url
    if object.image.present?
      object.image.url(:medium)
    end
  end
end
