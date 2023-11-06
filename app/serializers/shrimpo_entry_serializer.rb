class ShrimpoEntrySerializer < ActiveModel::Serializer
  attributes :title, :audio_file_url, :username

  def audio_file_url
  end

  def username
    object.user.username
  end
end
