require 'rails_helper'

RSpec.describe Subscription, :type => :model do
  let(:hobbyist_plan) { Plan.create name: "Hobbyist" }
  let(:owner) { FactoryGirl.create :user, username: "owner", role: "owner" }
  let!(:subscription) { FactoryGirl.create :subscription, user: owner }
  before do
    Time.zone = 'UTC'
    Timecop.freeze Time.local(2017,10,18)
  end
  after do
    Timecop.return
  end
  describe "#save_with_free_trial" do
    it "sets on trial to true and sets trial_ends_at date" do
      VCR.use_cassette "stripe_save_free_trial" do
        subscription.save_with_free_trial!
      end
      subscription.reload
      expect(subscription.on_trial?).to eq true
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
      it "uses a coupon" do
        VCR.use_cassette "stripe_use_coupon" do
          subscription.coupon = "COOLCOUPON2014"
          subscription.save_with_free_trial!
        end
      end
      it "updates the subscription with a new card"
      it "updates the subscription with a new plan"
      it "updates the subscription with a new card and plan and uses a coupon" do
        VCR.use_cassette "stripe_save_free_trial" do
          subscription.save_with_free_trial!
        end
        VCR.use_cassette "stripe_update_with_new_card_and_coupon" do
          token = Stripe::Token.create(
            :card => {
              :number => "4242424242424242",
              :exp_month => 7,
              :exp_year => 2019,
              :cvc => "314"
            }
          )
          result = subscription.update_with_new_card plan_id: hobbyist_plan.id, stripe_card_token: token.id, coupon: "COOLCOUPON2014"
          expect(result).to eq true
          subscription.reload
          expect(subscription.on_trial?).to eq false
          expect(subscription.on_paid_plan?).to eq true
          expect(subscription.plan).to eq hobbyist_plan
          customer = Stripe::Customer.retrieve subscription.stripe_customer_token
          expect(customer.subscriptions.data.first.plan.id).to eq "Hobbyist"
          expect(customer.discount.coupon.id).to eq "COOLCOUPON2014"
          expect(customer.discount.coupon.amount_off).to eq 1200
        end
      end
      it "updates the subscription with a new card and plan" do
        VCR.use_cassette "stripe_save_free_trial" do
          subscription.save_with_free_trial!
        end
        VCR.use_cassette "stripe_update_with_new_card" do
          token = Stripe::Token.create(
            :card => {
              :number => "4242424242424242",
              :exp_month => 7,
              :exp_year => 2019,
              :cvc => "314"
            }
          )
          subscription.update_with_new_card plan_id: hobbyist_plan.id, stripe_card_token: token.id
          subscription.reload
          expect(subscription.on_trial?).to eq false
          expect(subscription.on_paid_plan?).to eq true
          expect(subscription.plan).to eq hobbyist_plan
          customer = Stripe::Customer.retrieve subscription.stripe_customer_token
          expect(customer.subscriptions.data.first.plan.id).to eq "Hobbyist"
        end
      end
      it "doesn't save if the stripe api returned an error"
      it "doesn't let you use expired coupons" do
        VCR.use_cassette "stripe_save_free_trial" do
          subscription.save_with_free_trial!
        end
        VCR.use_cassette "stripe_update_with_new_card_and_expired_coupon" do
          token = Stripe::Token.create(
            :card => {
              :number => "4242424242424242",
              :exp_month => 7,
              :exp_year => 2019,
              :cvc => "314"
            }
          )
          result = subscription.update_with_new_card plan_id: hobbyist_plan.id, stripe_card_token: token.id, coupon: "reallycoolcoupon"
          expect(result).to eq false
          expect(subscription.errors.messages[:base]).to include("There was an error saving your billing information: Coupon expired: reallycoolcoupon.")
        end
      end
    end
  end
  describe "permissions" do
    it "user can manage their other subscription"
    it "user cannot manage another user's subscription"
  end
  describe "canceling" do
    it "cancels the subscription" do
      subscription.cancel!
      expect(subscription.canceled?).to eq true
    end
    it "disables the radio on the subscription" do
      radio = double("radio")
      allow(subscription).to receive(:radios) { [radio] }
      expect(radio).to receive(:disable_radio)
      subscription.cancel!
    end
  end

  describe "free trial ending" do
    it "cancels the stripe subscription" do
      VCR.use_cassette "stripe_cancel_subscription" do
        subscription.save_with_free_trial!
        subscription.reload
        expect(subscription.on_trial?).to eq true
        expect(subscription.trial_ends_at < 15.days.from_now).to eq true
        expect(subscription.trial_days_left).to eq 14

        subscription.cancel_stripe_subscription
        subscription.reload
        customer = Stripe::Customer.retrieve subscription.stripe_customer_token
        expect(customer.subscriptions.total_count).to eq 0
        expect(customer.subscriptions.data).to eq []
      end
    end
  end
end
