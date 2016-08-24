class UploadTrackToMixcloud
  def perform track, mixcloud_token
    unless File.exists?(track.local_path)
      DownloadTrackWorker.new.perform(track.id)
    end
    if track.artwork.present?
      artwork = download_tempfile track.artwork.url
      Mixcloud.client.new(token).upload track.local_path, track.title, artwork.path
    else
      Mixcloud.client.new(token).upload track.local_path, track.title
    end
  end
end
