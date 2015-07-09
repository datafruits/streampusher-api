class UserSignedUpNotifier
  def self.notify user
    AdminMailer.user_signed_up.deliver_later user
  end
end
