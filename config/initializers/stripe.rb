Stripe.api_key = ENV['STRIPE_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']

unless Rails.env.production?
  StripeEvent.event_retriever = lambda do |params|
    Stripe::Event.construct_from(params.deep_symbolize_keys)
  end
end

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.updated' do |event|
    StripeEventHandler.customer_subscription_updated event
  end
  events.subscribe 'customer.subscription.trial_will_end' do |event|
    # send warning email
    StripeEventHandler.trial_will_end event
  end
  events.subscribe 'invoice.payment_failed' do |event|
    # TODO
    # trial may have ended
    StripeEventHandler.payment_failed event
  end
  events.subscribe 'invoice.payment_succeeded' do |event|
    # TODO
    # trial may have ended
    StripeEventHandler.payment_succeeded event
  end
end
