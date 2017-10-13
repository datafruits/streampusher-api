class CollectStatsWorker < ActiveJob::Base
  queue_as :monitor

  def perform
    Radio.enabled.find_each do |radio|
      CollectStats.new(radio).perform
    end
  end
end
