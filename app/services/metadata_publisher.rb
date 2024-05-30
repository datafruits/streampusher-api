class MetadataPublisher
  def self.perform radio, metadata
    raise "blank title passed to MetadataUpdate" if metadata.blank?
    StreamPusher.redis.set "#{radio}:metadata", metadata.strip
    StreamPusher.redis.publish "#{radio}:metadata", metadata.strip
  end
end
