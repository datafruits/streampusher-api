class PlaylistTrackSerializer < ActiveModel::Serializer
  attributes :audio_file_name, :podcast_published_date, :id, :track_id, :playlist_id, :title, :display_name, :position

  def display_name
    object.track.display_name
  end

  def audio_file_name
    object.track.audio_file_name
  end

  def title
    object.track.display_name
  end
end
