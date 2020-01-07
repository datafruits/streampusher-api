require 'rails_helper'

describe StripeEventHandler do
  it "handles customer_subscription_updated" do
    user = FactoryBot.create :user, subscription: FactoryBot.create(:subscription, stripe_customer_token: "deadbeef")
    event = JSON.parse(File.read("spec/fixtures/stripe_events/customer.subscription.updated.json"), object_class: OpenStruct)
    StripeEventHandler.customer_subscription_updated event
  end
  xit "handles trial_will_end"
  xit "handles payment failed event"
  xit "handles trial ended event"
  xit "handles payment succeeded event"
end
