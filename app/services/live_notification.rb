class LiveNotification
  def self.perform radio, notification
    Redis.current.publish "#{radio}:notifications", notification
    ActiveSupport::Notifications.instrument 'live_now', radio: @current_radio.name, user: notification.split("--").last.strip
  end
end
