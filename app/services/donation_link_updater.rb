class DonationLinkUpdater
  def self.perform radio, link
    Redis.current.set "#{radio}:donation_link", link
    Redis.current.publish "#{radio}:donation_link", link
  end
end
