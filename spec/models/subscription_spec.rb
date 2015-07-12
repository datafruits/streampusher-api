require 'rails_helper'

RSpec.describe Subscription, :type => :model do
  let(:owner) { FactoryGirl.create :user, username: "owner", role: "owner" }
  let!(:subscription) { FactoryGirl.create :subscription, user: owner, plan: Plan.find_by_name("Free Trial") }
  describe "#save_with_free_trial" do
    it "sets on trial to true and sets trial_ends_at date" do
      VCR.use_cassette "stripe_save_free_trial" do
        subscription.save_with_free_trial
      end
      expect(subscription.on_trial).to eq true
      expect(subscription.trial_ends_at < 30.days.from_now).to eq true
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
      it "updates the subscription with a new card and plan"
      it "doesn't save if the stripe api returned an error"
    end
  end
  describe "permissions" do
    it "user can manage their other subscription"
    it "user cannot manage another user's subscription"
  end
end
