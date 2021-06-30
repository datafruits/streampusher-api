class SyncPatreonsWorker < ActiveJob::Base
  queue_as :default

  def perform
    SyncPatreons.perform
  end
end
