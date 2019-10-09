class MetadataPublisher
  def self.perform metadata
    Redis.current.set "datafruits:metadata", metadata
    Redis.current.publish "datafruits:metadata", metadata
  end
end
