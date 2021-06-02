class ScheduleMonitor
  def self.perform radio, now, liquidsoap_socket_class=Liquidsoap::Socket
    current_playing_show_id = radio.current_show_playing
    if current_playing_show_id.present?
      current_playing_show_in_redis = ScheduledShow.find(current_playing_show_id) # in redis
    else
      current_playing_show_in_redis = nil
    end
    current_scheduled_show_in_db = radio.current_scheduled_show now # database
    # 3 cases
    if !current_scheduled_show_in_db  # no show scheduled now, clear it
      puts "no current show, clearing redis"
      radio.set_current_show_playing nil
    elsif current_scheduled_show_in_db && (current_scheduled_show_in_db.id != current_playing_show_in_redis.try(:id).to_i) # its not the next show yet, but next_track will set it
      # add next show's track (or entire playlist?) to queue
      puts "adding to queue"
      current_scheduled_show_in_db.queue_playlist!
      puts "received queue_playlist!"
      # if previous show is set to no_cue_out, or previous show is blank, time to skip!
      if current_playing_show_in_redis.blank? || !current_playing_show_in_redis.playlist.no_cue_out? # check cue out of previous show
        puts "skipping"
        liquidsoap = LiquidsoapRequests.new radio.id
        liquidsoap.skip
      end
      # current_scheduled_show_in_db and redis should sync
      radio.set_current_show_playing current_scheduled_show_in_db.id
    else
      puts "current show is already playing and queued?"
    end
  end
end
