class PatreonWebhookHandler
  def self.perform data
    pledge_amount_cents = data["attributes"]["pledge_amount_cents"]
    name = data["attributes"]["full_name"].split(" ").first
    pledge = PatreonPledge.create! json_blob: data, name: name, pledge_amount_cents: pledge_amount_cents
    Notification.create! notification_type: "patreon_sub", send_to_chat: true, send_to_user: false, source: pledge, user_id: 1
  end
end
