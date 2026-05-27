class CustomEmojiSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_url, :user_emojis_usernames

  def user_emojis_usernames
    object.user_emojis.map {|m| m.user.username}
  end

  def image_url
    return unless object.image.attached?

    Rails.application.routes.url_helpers.rails_blob_url(
      object.image,
      host: Rails.application.routes.default_url_options[:host]
    )
  end
end
