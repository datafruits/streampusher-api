class MetadataPublisher
  def self.perform radio, metadata
    Redis.current.set "#{radio}:metadata", metadata
    Redis.current.publish "#{radio}:metadata", metadata
  end
end
