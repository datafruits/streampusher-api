class UploadTrackToMixcloud
  def perform track, mixcloud_token
    Mixcloud.client.new(token).upload track.title
  end
end
