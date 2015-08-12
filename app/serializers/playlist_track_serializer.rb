class PlaylistTrackSerializer < ActiveModel::Serializer
  attributes :audio_file_name, :podcast_published_date, :id, :track_id, :playlist_id

  def audio_file_name
    object.track.audio_file_name
  end
end
