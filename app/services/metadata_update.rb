class MetadataUpdate
  def self.perform radio, metadata
    liquidsoap_socket = Liquidsoap::Socket.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write "metadata.update #{equalify_hash(metadata)}"
  end

  private
  def self.equalify_hash hash
    hash.map{|k,v| "#{k}=#{v}" }.join(",")
  end
end
