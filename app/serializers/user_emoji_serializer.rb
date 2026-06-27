class UserEmojiSerializer < ActiveModel::Serializer
  attributes :user_id, :custom_emoji_id, :name, :image_url

  def name
    object.custom_emoji.name
  end

  def image_url
    return unless object.custom_emoji.image.attached?

    Rails.application.routes.url_helpers.rails_blob_url(
      object.custom_emoji.image,
      host: Rails.application.routes.default_url_options[:host]
    )
  end
end
