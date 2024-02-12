class ShrimpoEntrySerializer < ActiveModel::Serializer
  attributes :title, :audio_file_url, :username, :user_avatar, :slug, :user_role, :cdn_url
  belongs_to :shrimpo

  def audio_file_url
  end

  def cdn_url
    if object.audio.present?
      if ::Rails.env != "production"
        ::Rails.application.routes.url_helpers.rails_blob_path(object.audio, only_path: true, disposition: 'attachment')
      else
        object.audio.url
      end
    end
  end

  def user_role
    object.user.role
  end

  def username
    object.user.username
  end

  def user_avatar
    CGI.unescape(object.user.image.url(:thumb))
  end
end
