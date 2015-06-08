require 'rails_helper'

RSpec.describe Subscription, :type => :model do
  describe "permissions" do
    it "user can manage their other subscription"
    it "user cannot manage another user's subscription"
  end
end
