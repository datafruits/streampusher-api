class PatreonWebhookHandler
  def self.perform
    Notification.create! notification_type: "patreon_sub", send_to_chat: true, send_to_user: false
  end
end
