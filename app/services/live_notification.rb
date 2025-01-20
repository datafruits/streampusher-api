class LiveNotification
  def self.perform radio, notification
    title = notification
    user = notification.split("--").last.strip
    ::StreamPusher.redis.publish "#{radio}:notifications", notification
    ActiveSupport::Notifications.instrument 'live_now', radio: radio, user: user
    # store current live and show id in redis
    current_show = { title: title, user: user }

    r = Radio.find_by name: radio
    s = r.current_scheduled_show
    if s.present? && s.dj.username == user
      current_show[:scheduled_show] = s.id
    else
      current_show[:scheduled_show] = nil
    end

    # why does this fail
    ::StreamPusher.redis.hset "#{radio}:current_show", current_show
  end
end
