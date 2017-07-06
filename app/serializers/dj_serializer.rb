class DjSerializer < ActiveModel::Serializer
  attributes :id, :username, :image_url, :bio

  def image_url
    if object.image.present?
      object.image.url
    end
  end
end
