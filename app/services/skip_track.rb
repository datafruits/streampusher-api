class SkipTrack
  def self.perform radio
    liquidsoap = LiquidsoapRequests.new radio.id
    liquidsoap.skip
    ScheduleMonitor.perform radio, Time.now
  end
end
