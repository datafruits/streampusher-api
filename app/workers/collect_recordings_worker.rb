class CollectRecordingsWorker < ActiveJob::Base
  queue_as :default
  def perform
    Radio.enabled.find_each do |radio|
      radio.recording_files.each do |file|
        unless Recording.where(path: file).any?
          Recording.create radio: radio, path: file
        end
      end
    end
  end
end
