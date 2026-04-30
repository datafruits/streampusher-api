class UserEmojiSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_url

  def image_url
    if object.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true)
    end
  end
end
