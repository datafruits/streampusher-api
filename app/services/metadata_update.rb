class MetadataUpdate
  def self.perform radio, metadata
    metadata = massage_metadata metadata
    liquidsoap_socket = Liquidsoap::Socket.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write "metadata.update #{equalify_hash(metadata)}"
  end

  private
  def self.equalify_hash hash
    hash.map{|k,v| "#{k}=#{v}" }.join(",")
  end

  def self.massage_metadata metadata
    [:artist, :album, :title].each do |key|
      unless metadata.has_key? key
        metadata[key] = " "
      end
    end
    metadata
  end
end
