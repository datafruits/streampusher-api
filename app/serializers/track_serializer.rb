class TrackSerializer < ActiveModel::Serializer
  attributes :id, :audio_file_name, :display_name, :artist, :title, :album,
    :created_at, :updated_at, :artwork, :artwork_filename, :mixcloud_upload_status, :mixcloud_key,
    :embed_link, :cdn_url, :label_ids

  def embed_link
    if ::Rails.env.production?
      "http://#{object.radio.virtual_host}/tracks/#{object.id}/embed"
    else
      "http://#{object.radio.virtual_host}:3000/tracks/#{object.id}/embed"
    end
  end

  def cdn_url
    object.cdn_url
  end

  def mixcloud_upload_status
    object.mixcloud_upload_status
  end

  def artwork
    if object.artwork.present?
      {
        basename: object.artwork_file_name,
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
