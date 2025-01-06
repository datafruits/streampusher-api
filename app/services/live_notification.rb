class LiveNotification
  def self.perform radio, notification
    title = notification
    user = notification.split("--").last.strip
    StreamPusher.redis.publish "#{radio}:notifications", notification
    ActiveSupport::Notifications.instrument 'live_now', radio: radio, user: notification.split("--").last.strip
    # store current live and show id in redis
    current_show = { title: title, user: user }

    r = Radio.find_by name: radio
    s = r.current_scheduled_show
    if s
      current_show[:scheduled_show] = s.id
    end

    Streampusher.redis.hset "#{radio}:current_show", current_show
  end
end
