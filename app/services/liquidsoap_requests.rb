class LiquidsoapRequests
  def self.alive radio, liquidsoap_socket_class=Liquidsoap::Socket
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write("request.alive").gsub(/END/, "").split(" ")
  end

  def self.on_air radio, liquidsoap_socket_class=Liquidsoap::Socket
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write "request.on_air"
  end

  def self.metadata radio, rid, liquidsoap_socket_class=Liquidsoap::Socket
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write "request.metadata #{rid}"
  end
end
