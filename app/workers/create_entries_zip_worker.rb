class CreateEntriesZipWorker < ActiveJob::Base
  queue_as :default

  def perform shrimpo_id
    shrimpo = Shrimpo.find shrimpo_id
    return unless shrimpo.completed?
    shrimpo.create_entries_zip
  end
end
