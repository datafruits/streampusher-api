class UploadTrackToMixcloudWorker < ActiveJob::Base
  queue_as :default

  def perform track_id, mixcloud_token
    track = Track.find_by! id: track_id

    UploadTrackToMixcloud.new.perform track, mixcloud_token
  end
end
