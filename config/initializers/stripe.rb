Stripe.api_key = ENV['STRIPE_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']

unless Rails.env.production?
  StripeEvent.event_retriever = lambda do |params|
    Stripe::Event.construct_from(params.deep_symbolize_keys)
  end
end

StripeEvent.event_retriever = lambda do |params|
  return nil if StripeWebhook.exists?(stripe_id: params[:id])
  StripeWebhook.create!(stripe_id: params[:id])
  Stripe::Event.retrieve(params[:id])
end

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.updated' do |event|
    puts event.inspect
    StripeEventHandler.customer_subscription_updated event
  end
  events.subscribe 'customer.subscription.trial_will_end' do |event|
    puts event.inspect
    StripeEventHandler.trial_will_end event
  end
  events.subscribe 'invoice.payment_failed' do |event|
    puts event.inspect
    StripeEventHandler.payment_failed event
  end
  events.subscribe 'invoice.payment_succeeded' do |event|
    puts event.inspect
    StripeEventHandler.payment_succeeded event
  end
end
