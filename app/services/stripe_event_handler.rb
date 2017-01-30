class StripeEventHandler
  def self.customer_subscription_updated event
    user = Subscription.find_by!(stripe_customer_token: event.data.object.customer).user
    if event.data.previous_attributes.try(:plan)
      old_plan = event.data.previous_attributes.plan.id
      new_plan = event.data.object.plan.id
      AccountMailer.subscription_updated(user, old_plan, new_plan).deliver_later
    elsif event.data.object.plan.name == "Free Trial"
      if user.subscription.trial_ends_at < Date.today
        AccountMailer.trial_ended(user).deliver_later
      end
    end
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
      if user.subscription.trial_ends_at < Date.today
        AccountMailer.trial_ended(user).deliver_later
      end
    else
      invoice = event.data.object
      AccountMailer.payment_failed(user, invoice).deliver_later
    end
  end

  def self.payment_succeeded event
    # figure out if this is an ended free trial
    subscription = Subscription.find_by!(stripe_customer_token: event.data.object.customer)
    user = subscription.user
    if event.data.object.lines.data[0].plan.id == "Free Trial"
      if subscription.trial_ends_at < Date.today
        AccountMailer.trial_ended(user).deliver_later
      end
    else
      invoice = {}
      invoice[:currency] = event.data.object.currency
      invoice[:amount] = event.data.object.lines.data[0].amount
      invoice[:id] = event.data.object.id
      invoice[:plan_id] = event.data.object.lines.data[0].plan.id
    end

    AccountMailer.invoice(user, invoice).deliver_later
  end
end
