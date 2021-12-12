class ArchiveMicrotextWorker < ActiveJob::Base
  queue_as :default

  def perform microtext_id
    Microtext.find(microtext_id).update archived: true
  end
end
