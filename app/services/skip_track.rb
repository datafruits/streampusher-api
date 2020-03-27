class SkipTrack
  def self.perform radio, liquidsoap_socket_class=Liquidsoap::Socket
    liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
    liquidsoap_socket.write "icecast.1.skip"
  end
end
