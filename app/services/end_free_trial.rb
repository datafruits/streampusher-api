class EndFreeTrial
  def self.perform subscription
    subscription.trial_ended!
    radio = subscription.radios.first
    RadioDisableWorker.perform_later(radio)
  end
end
