require 'rails_helper'

RSpec.describe Subscription, :type => :model do
  let(:hobbyist_plan) { Plan.create name: "Hobbyist" }
  let(:owner) { FactoryGirl.create :user, username: "owner", role: "owner" }
  let!(:subscription) { FactoryGirl.create :subscription, user: owner }
  before do
    Time.zone = 'UTC'
    Timecop.freeze Time.local(2016,5,13)
  end
  after do
    Timecop.return
  end
  describe "#save_with_free_trial" do
    it "sets on trial to true and sets trial_ends_at date" do
      VCR.use_cassette "stripe_save_free_trial" do
        subscription.save_with_free_trial
      end
      subscription.reload
      expect(subscription.on_trial).to eq true
      expect(subscription.trial_ends_at < 15.days.from_now).to eq true
      expect(subscription.trial_days_left).to eq 14
    end
  end
  context "adding and updating cards" do
    describe "saving a new subscription" do
      it "saves the subscription with a new card and plan"
      it "doesn't save if the stripe api returned an error"
    end
    describe "updating the card and/or plan" do
      it "updates the subscription with a new card"
      it "updates the subscription with a new plan"
      it "updates the subscription with a new card and plan" do
        VCR.use_cassette "stripe_save_free_trial" do
          subscription.save_with_free_trial
        end
        VCR.use_cassette "stripe_update_with_new_card" do
          token = Stripe::Token.create(
            :card => {
              :number => "4242424242424242",
              :exp_month => 7,
              :exp_year => 2016,
              :cvc => "314"
            }
          )
          subscription.update_with_new_card plan_id: hobbyist_plan.id, stripe_card_token: token.id
        end
        subscription.reload
        expect(subscription.on_trial).to eq false
      end
      it "doesn't save if the stripe api returned an error"
    end
  end
  describe "permissions" do
    it "user can manage their other subscription"
    it "user cannot manage another user's subscription"
  end
  describe "canceling" do
    it "cancels the subscription" do
      subscription.cancel!
      expect(subscription.canceled).to eq true
    end
    it "disables the radio on the subscription" do
      radio = double("radio")
      allow(subscription).to receive(:radios) { [radio] }
      expect(radio).to receive(:disable_radio)
      subscription.cancel!
    end
  end
end
