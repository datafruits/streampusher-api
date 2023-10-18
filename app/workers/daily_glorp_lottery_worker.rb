class DailyGlorpLotteryWorker < ActiveJob::Base
  queue_as :default

  def perform
    DailyGlorpLottery.new.draw!
  end
end
