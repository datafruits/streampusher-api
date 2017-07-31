require 'rails_helper'
require 'sidekiq/testing'

describe UserSignedUpNotifier do
  before do
    Sidekiq::Testing.fake!
  end

  it "sets up the onboarding drip campaign" do
    user = FactoryGirl.create :user
    UserSignedUpNotifier.notify user
  end
end
