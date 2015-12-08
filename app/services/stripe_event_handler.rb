class StripeEventHandler
  def self.customer_subscription_updated event
    #user = Subscription.find_by!(stripe_customer_token: event.data.object.customer).user
    #AccountMailer.trial_ended(user).deliver_later
  end

  def self.trial_will_end
    # send warning email
    user = Subscription.find_by!(stripe_customer_token: event.data.object.customer).user
    AccountMailer.trial_will_end(user).deliver_later
  end

  def self.payment_failed

  end

  def self.payment_succeeded

  end
end
