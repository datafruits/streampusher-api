class LiveNotification
  def self.perform radio, notification
    Redis.current.publish "#{radio}:notifications", notification
  end
end
