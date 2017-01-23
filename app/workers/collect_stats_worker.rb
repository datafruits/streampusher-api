class CollectStatsWorker < ActiveJob::Base
  queue_as :default

  def perform
    Radio.find_each do |radio|
      CollectStats.new(radio).perform
    end
  end
end
