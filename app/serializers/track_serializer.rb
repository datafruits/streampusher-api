class TrackSerializer < ActiveModel::Serializer
  attributes :id, :audio_file_name, :display_name, :artist, :title, :album,
    :created_at, :artwork, :artwork_filename, :mixcloud_upload_status, :mixcloud_key

  def mixcloud_upload_status
    object.mixcloud_upload_status
  end

  def artwork
    if object.artwork.present?
      {
        filename: object.artwork_file_name,
        attachment: "artworks",
        updated_at: object.artwork.updated_at
      }
    end
  end

  def artwork_filename
    if object.artwork.present?
      object.artwork_file_name
    end
  end

  def display_name
    object.display_name
  end
end
