class UserSignedUpNotifier
  def self.notify user
    AdminMailer.user_signed_up(user).deliver_later user
  end
end
