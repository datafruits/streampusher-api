class StripeEventHandler
  def self.customer_subscription_updated event
    user = Subscription.find_by!(stripe_customer_token: event.data.object.customer).user
    old_plan = event.data.previous_attributes.plan
    new_plan = event.data.object.plan
    AccountMailer.subscription_updated(user).deliver_later
  end

  def self.trial_will_end event
    # send warning email
    user = Subscription.find_by!(stripe_customer_token: event.data.object.customer).user
    AccountMailer.trial_will_end(user).deliver_later
  end

  def self.payment_failed event
    # figure out if this is an ended free trial
    # or
    # a failed charge
    user = Subscription.find_by!(stripe_customer_token: event.data.object.customer).user
    if event.data.object.lines.data[0].plan.id == "Free Trial"
      AccountMailer.trial_ended(user).deliver_later
    else
      invoice = event.data.object
      AccountMailer.payment_failed(user, invoice).deliver_later
    end
  end

  def self.payment_succeeded event
    user = Subscription.find_by!(stripe_customer_token: event.data.object.customer).user
    invoice = event.data.object
    AccountMailer.invoice(user, invoice).deliver_later
  end
end
