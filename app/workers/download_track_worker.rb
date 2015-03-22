class DownloadTrackWorker < ActiveJob::Base
  queue_as :default

  def perform track_id
    track = Track.find track_id
    line = Cocaine::CommandLine.new("wget", "-q :file -O :dest")
    line.run(file: track.audio_file_name, dest: track.local_path)
  end
end
