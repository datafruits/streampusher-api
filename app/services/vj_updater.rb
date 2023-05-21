class VjUpdater
  def self.perform enabled, radio
    StreamPusher.redis.set "#{radio}:vj", enabled
    StreamPusher.redis.publish "#{radio}:vj", enabled
  end
end
