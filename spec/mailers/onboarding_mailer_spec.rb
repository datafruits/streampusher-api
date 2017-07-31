require "rails_helper"

RSpec.describe OnboardingMailer, type: :mailer do
  let(:user){ FactoryGirl.create :user, subscription: FactoryGirl.create(:subscription) }
  it "sends playlists email" do
    mail = OnboardingMailer.playlists(user).deliver_now
  end

  it "sends broadcasting help email" do
    mail = OnboardingMailer.broadcasting(user).deliver_now
  end

  it "sends stats help email" do
    mail = OnboardingMailer.stats(user).deliver_now
  end

  it "sends djs help email" do
    mail = OnboardingMailer.djs(user).deliver_now
  end

end
