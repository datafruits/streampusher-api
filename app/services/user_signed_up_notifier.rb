class UserSignedUpNotifier
  def self.notify user
    AdminMailer.user_signed_up(user).deliver_later
    AccountMailer.welcome_new_account(user).deliver_later
    AccountMailer.welcome_new_account_personalized(user).deliver_later wait: 2.days
    if ::Rails.env == "production"
      ga_event("user", "signup")
    end
  end
end
