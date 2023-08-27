class ShrimpoEntrySerializer < ActiveModel::Serializer
  attributes :title, :audio_file_url, :user

  def audio_file_url
  end
end
