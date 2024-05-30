class DonationLinkUpdater
  def self.perform radio, link
    StreamPusher.redis.set "#{radio}:donation_link", link
    StreamPusher.redis.publish "#{radio}:donation_link", link
  end
end
