require 'rails_helper'

RSpec.describe HostApplication, type: :model do
  it "it tells you if the username is taken" do
    FactoryGirl.create :user, username: "yoshibo"
    host_application = FactoryGirl.build :host_application, username: "yoshibo"
    expect(host_application.valid?).to eq false
    expect(host_application.errors[:username]).to be_present
  end
  it "it tells you if the email is taken" do
    FactoryGirl.create :user, email: "yoshibo@malboro.info"
    host_application = FactoryGirl.build :host_application, email: "yoshibo@malboro.info"
    expect(host_application.valid?).to eq false
    expect(host_application.errors[:email]).to be_present
  end
  it "approves the application" do
    host_application = FactoryGirl.create :host_application
    host_application.approve!
    expect(User.where(username: host_application.username, email: host_application.email, time_zone: host_application.time_zone).count).to eq 1
    expect(host_application.approved?).to eq true
  end
end
