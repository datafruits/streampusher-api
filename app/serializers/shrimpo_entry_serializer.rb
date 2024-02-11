class ShrimpoEntrySerializer < ActiveModel::Serializer
  attributes :title, :audio_file_url, :username, :user_avatar, :slug
  belongs_to :shrimpo

  def audio_file_url
  end

  def username
    object.user.username
  end

  def user_avatar
    CGI.unescape(object.user.image.url(:thumb))
  end
end
