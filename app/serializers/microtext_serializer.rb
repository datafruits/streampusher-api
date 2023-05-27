class MicrotextSerializer < ActiveModel::Serializer
  attributes :content, :id, :username, :avatar_url, :created_at

  def username
    object.user.username
  end

  def avatar_url
    if object.user.image.present?
      CGI.unescape(object.user.image.url(:thumb))
    end
  end
end
