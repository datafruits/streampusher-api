class EndFreeTrial
  def self.perform subscription
    subscription.trial_ended!
    subscription.cancel_stripe_subscription
    # radio = subscription.radios.first
    # RadioDisableWorker.perform_later(radio)
  end
end
