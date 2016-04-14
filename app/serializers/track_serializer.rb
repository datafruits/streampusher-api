class TrackSerializer < ActiveModel::Serializer
  attributes :id, :audio_file_name, :display_name, :artist, :title, :album, :created_at

  def display_name
    object.display_name
  end
end
