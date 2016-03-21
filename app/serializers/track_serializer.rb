class TrackSerializer < ActiveModel::Serializer
  attributes :id, :audio_file_name, :display_name, :artist, :title, :album

  def display_name
    object.display_name
  end
end
