class MetadataUpdate
  def self.perform radio, metadata, liquidsoap_socket_class=Liquidsoap::Socket
    metadata = massage_metadata metadata
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write "metadata.update #{equalify_hash(metadata)}"
  end

  private
  def self.equalify_hash hash
    Hash(hash).map{|k,v| "#{k}=#{v}" }.join(",")
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
