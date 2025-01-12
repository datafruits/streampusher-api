class ScheduleMonitorWorker < ActiveJob::Base
  queue_as :monitor

  def perform
    now = Time.now
    Radio.enabled.find_each do |radio|
      ScheduleMonitor.perform radio, now
    end
  end
end
