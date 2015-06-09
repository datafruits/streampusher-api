Stripe.api_key = ENV['STRIPE_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.updated' do |event|
    # trial may have ended
  end
  events.subscribe 'customer.subscription.trial_will_end' do |event|
    # send warning email
  end
end
