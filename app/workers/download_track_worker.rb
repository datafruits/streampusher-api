require 'open-uri'

class DownloadTrackWorker < ActiveJob::Base
  queue_as :default

  def perform track_id
    track = Track.find_by! id: track_id

    File.open(track.local_path, "wb") do |saved_file|
      open(track.audio_file_name, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end
end
