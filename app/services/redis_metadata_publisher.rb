class RedisMetadataPublisher
  def self.perform radio, metadata
    raise "blank title passed to RedisMetadataPublisher" if metadata.blank?
    StreamPusher.redis.set "#{radio}:metadata", metadata.strip
    StreamPusher.redis.publish "#{radio}:metadata", metadata.strip
  end
end