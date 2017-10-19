require 'rails_helper'

describe EndFreeTrial do
  it "disables the radio and sets the subscription to trial_ended" do
    user = FactoryGirl.create :user, subscription: FactoryGirl.create(:subscription, stripe_customer_token: "deadbeef")
    # radio = FactoryGirl.create :radio, subscription: user.subscription
    subscription = user.subscription
    #allow(RadioDisableWorker).to receive(:perform_later).with(radio)
    EndFreeTrial.perform(subscription)

    expect(subscription.trial_ended?).to eq true
  end
end
