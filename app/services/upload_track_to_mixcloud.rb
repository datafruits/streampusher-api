require './lib/download_tempfile'

class UploadTrackToMixcloud
  def perform track, mixcloud_token
    track.mixcloud_upload_status = "mixcloud_uploading"
    track.save(validate: false)
    unless File.exists?(track.local_path)
      DownloadTrackWorker.new.perform(track.id)
    end
    # TODO rescue network errors
    if track.artwork.present?
      artwork = download_tempfile track.artwork.url
      result = Mixcloud::Client.new(mixcloud_token).upload track.local_path, track.title, artwork.path
    else
      result = Mixcloud::Client.new(mixcloud_token).upload track.local_path, track.title
    end
    if result["result"]["success"] = true
      track.mixcloud_upload_status = "mixcloud_upload_complete"
      track.mixcloud_key = result["result"]["key"]
    else
      track.mixcloud_upload_status = "mixcloud_upload_failed"
    end
    track.save(validate: false)
    result
  end
end
