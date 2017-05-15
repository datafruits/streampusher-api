class ScheduleMonitorWorker < ActiveJob::Base
  queue_as :default

  def perform
    now = Time.now
    Radio.find_each do |radio|
      ScheduleMonitor.perform radio, now
    end
  end
end
