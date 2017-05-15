class ScheduleMonitor
  def self.perform radio, now, liquidsoap_socket_class=Liquidsoap::Socket
    current_playing_show_id = Redis.current.get radio.current_show_playing_key
    current_scheduled_show = radio.current_scheduled_show now
    if current_scheduled_show && (current_scheduled_show.id != current_playing_show_id.to_i)
      # skip!
      liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
      liquidsoap_socket.write "icecast.1.skip"
    end
  end
end
