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
    elsif current_scheduled_show_in_db && (current_scheduled_show_in_db.id.to_i != current_playing_show_in_redis.try(:id).to_i)
      # add next show's playlist? to queue
      unless current_scheduled_show_in_db.is_live? || current_scheduled_show_in_db.playlist.id == radio.default_playlist.id
        puts "adding to queue"
        current_scheduled_show_in_db.queue_playlist!
        puts "received queue_playlist!"
      else
        # hacks
        puts "shouldn't queue a playlist for a live show!"
      end
      # current_scheduled_show_in_db and redis should sync
      radio.set_current_show_playing current_scheduled_show_in_db.id
      # TODO set current_show metadata here
      # TODO when to clear this ??
      #
      # on fallback switch???
      current_show = { title: current_scheduled_show_in_db.title, user: current_scheduled_show_in_db.user.username }
      StreamPusher.redis.hset "#{radio}:current_show", current_show
    else
      puts "current show is already playing and queued?"
    end
  end
end
