require 'uri'

class MergeRecordingsWorker < ActiveJob::Base
  queue_as :default

  def perform new_filename, *recordings
    storage = recordings.first.file.options.fetch(:storage)

    if storage == :s3
      filenames = []
      tempfiles = []
      recordings.each do |recording|
        uri = URI.parse(recording.file(:original))
        t = Tempfile.new([File.basename(uri.path, ".*"), File.extname(uri.path)])
        t.binmode
        t.write(URI.parse(recording.file(:original)).open.read)
        filenames << t.path
        tempfiles << t
      end
    else
      filenames = recordings.map{|r| r.file.path}
    end

    Sox.merge new_filename, *filenames

    if storage == :s3
      tempfiles.each do |t|
        t.close
        t.unlink
      end
    end

    Recording.create! file: File.new(new_filename), radio_id: recordings.first.radio_id, dj_id: recordings.first.dj_id, show_id: recordings.first.show_id
  end
end
