require 'factory_bot'

FactoryBot.define do
  factory :gift_subscription do
    association :gifter, factory: :user
    association :giftee, factory: :user
    amount { 7.00 }
    status { :pending }
    stripe_payment_intent_id { "pi_test_#{SecureRandom.hex(12)}" }
    message { "Enjoy your premium membership!" }
  end

  factory :active_gift_subscription, parent: :gift_subscription do
    status { :active }
    activated_at { Time.current }
    expires_at { 1.month.from_now }
  end

  factory :expired_gift_subscription, parent: :gift_subscription do
    status { :expired }
    activated_at { 2.months.ago }
    expires_at { 1.month.ago }
  end
end
