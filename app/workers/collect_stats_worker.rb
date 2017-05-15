class CollectStatsWorker < ActiveJob::Base
  queue_as :default

  def perform
    Radio.enabled.where(stats_enabled: true).find_each do |radio|
      CollectStats.new(radio).perform
    end
  end
end
