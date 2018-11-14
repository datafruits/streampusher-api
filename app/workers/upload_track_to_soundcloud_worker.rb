class UploadTrackToSoundcloudWorker < ActiveJob::Base
  queue_as :default

  def perform track_id, soundcloud_token
    track = Track.find_by! id: track_id

    UploadTrackToSoundcloud.new.perform track, soundcloud_token
  end
end
