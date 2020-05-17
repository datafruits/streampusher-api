class ScheduleMonitor
  def self.perform radio, now, liquidsoap_socket_class=Liquidsoap::Socket
    current_playing_show = ScheduledShow.find(Redis.current.get(radio.current_show_playing_key).to_i)
    current_scheduled_show = radio.current_scheduled_show now
    if current_scheduled_show && (current_scheduled_show.id != current_playing_show.id.to_i)
      liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)
      on_air_file = LiquidsoapRequests.on_air_file
      # dont skip if current show is not over yet
      if current_playing_show.playlist.no_cue_out?
        # add next show's track to queue
        LiquidsoapRequests.add_to_queue current_playing_show.next_track
        # how to set current playing show when that next track plays??
      else
        # skip!
        # unless queue.length == 1 && on_air_file == current_scheduled_show.playlist.tracks.first.audio_file_name
        #   clear queue
        #   while queue.length > 1
        #     liquidsoap_socket.write "icecast.1.skip"
        #   end
        # end
      end
    end
  end
end
