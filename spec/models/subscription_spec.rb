require 'rails_helper'

RSpec.describe Subscription, :type => :model do
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
