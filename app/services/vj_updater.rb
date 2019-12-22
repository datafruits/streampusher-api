class VjUpdater
  def self.perform enabled, radio
    Redis.current.set "#{radio}:vj", enabled
    Redis.current.publish "#{radio}:vj", enabled
  end
end
