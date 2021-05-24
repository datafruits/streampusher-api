class ScheduleMonitor
  def self.perform radio, now, liquidsoap_socket_class=Liquidsoap::Socket
    current_playing_show_id = radio.current_show_playing
    if current_playing_show_id.present?
      current_playing_show_in_redis = ScheduledShow.find(current_playing_show_id) # in redis
    else
      current_playing_show_in_redis = nil
    end
    current_scheduled_show_in_db = radio.current_scheduled_show now # database
    if !current_scheduled_show_in_db  # no show scheduled now, clear it
      radio.set_current_show_playing nil
    elsif current_scheduled_show_in_db && (current_scheduled_show_in_db.id != current_playing_show_in_redis.try(:id).to_i) # its not the next show yet, but next_track will set it
      liquidsoap_socket = liquidsoap_socket_class.new(radio.liquidsoap_socket_path)

      radio.set_current_show_playing current_scheduled_show_in_db.id
      # current_scheduled_show_in_db and redis are synced now

      if current_playing_show_in_db.playlist.no_cue_out?
        # add next show's track (or entire playlist?) to queue
        puts "adding to queue"
        current_playing_show_in_db.queue_playlist!
      else
        puts "skipping"
        current_playing_show_in_db.queue_playlist!
        LiquidsoapRequests.skip radio
      end
    end
  end
end
