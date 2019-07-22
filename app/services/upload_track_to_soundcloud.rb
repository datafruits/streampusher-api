require './lib/download_tempfile'

class UploadTrackToSoundcloud
  def perform track, soundcloud_token
    track.soundcloud_upload_status = "soundcloud_uploading"
    track.save(validate: false)
    unless File.exists?(track.local_path)
      DownloadTrackWorker.new.perform(track.id)
    end
    client = SoundCloud.new(:access_token => soundcloud_token)

    begin
      if track.artwork.present?
        artwork = download_tempfile track.artwork.url
        # upload a new track with audio.mp3 as audio and image.jpg as artwork
        result = client.post('/tracks', :track => {
          :title      => track.title,
          :asset_data => File.new(track.local_path),
          :artwork_data => File.new(artwork.path),
          :genre => track.labels.pluck(:name).first,
          :tag_list => track.labels.pluck(:name).drop(1).join(" ")
        })
      else
        result = client.post('/tracks', :track => {
          :title      => track.title,
          :asset_data => File.new(track.local_path)
        })
      end
    rescue SoundCloud::ResponseError => e
      puts "soundcloud response error: #{e}"
      track.soundcloud_upload_status = "soundcloud_upload_failed"
      track.save(validate: false)
      return
    end

    # print new tracks link
    puts result.permalink_url
    track.soundcloud_upload_status = "soundcloud_upload_complete"
    track.soundcloud_key = result.permalink_url
    track.save(validate: false)
  end
end
