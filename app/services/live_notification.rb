class LiveNotification
  def self.perform radio, notification
    StreamPusher.redis.publish "#{radio}:notifications", notification
    ActiveSupport::Notifications.instrument 'live_now', radio: radio, user: notification.split("--").last.strip
  end
end
