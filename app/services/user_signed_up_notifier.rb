class UserSignedUpNotifier
  def self.notify user
    AdminMailer.user_signed_up(user).deliver_later
    AccountMailer.welcome_new_account(user).deliver_later
  end
end
