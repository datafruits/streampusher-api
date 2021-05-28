class LiquidsoapRequests
  def self.alive radio, liquidsoap_socket_class=Liquidsoap::Socket
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write("request.alive").gsub(/END/, "").split(" ")
  end

  def self.on_air radio, liquidsoap_socket_class=Liquidsoap::Socket
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write("request.on_air").gsub(/END/, "").split(" ").first
  end

  def self.metadata radio, rid, liquidsoap_socket_class=Liquidsoap::Socket
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write("request.metadata #{rid}").force_encoding("UTF-8")
  end

  def self.on_air_filename radio
    on_air_rid = self.on_air radio
    metadata_line = self.metadata radio, on_air_rid
    metadata_line.split("\n")
    uri_line = metadata_line.split("\n").select{ |m| m.include?("initial_uri")}.first
    return uri_line.split(",").select{ |m| m.include?("http") }.first.split(":").last(2).join(":")
  end

  def self.add_to_queue radio, uri, liquidsoap_socket_class=Liquidsoap::Socket
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write("scheduled_shows.push #{uri}").encode("UTF-8")
  end

  def self.skip radio, liquidsoap_socket_class=Liquidsoap::Socket
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write("icecast.1.skip").encode("UTF-8")
  end
end
