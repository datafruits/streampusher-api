class DstFallForwardWorker < ActiveJob::Base
  queue_as :default

  def perform radio
    radio.scheduled_shows.in_dst_time_zones.find_each do |show|
      show.fall_forward_recurrances_for_dst!
    end
  end
end
