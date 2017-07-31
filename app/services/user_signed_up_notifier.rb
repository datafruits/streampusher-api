class UserSignedUpNotifier
  def self.notify user
    AdminMailer.user_signed_up(user).deliver_later
    AccountMailer.welcome_new_account(user).deliver_later
    AccountMailer.welcome_new_account_personalized(user).deliver_later wait: 2.days
    OnboardingMailer.playlists(user).deliver_later wait: 3.days
    OnboardingMailer.broadcasting(user).deliver_later wait: 4.days
    OnboardingMailer.djs(user).deliver_later wait: 5.days
    OnboardingMailer.stats(user).deliver_later wait: 6.days
    AccountMailer.day_after_trial_ended(user).deliver_later wait: 8.days
  end
end
