class MetadataPublisher
  def self.perform radio, metadata
    StreamPusher.redis.set "#{radio}:metadata", metadata
    StreamPusher.redis.publish "#{radio}:metadata", metadata
  end
end
