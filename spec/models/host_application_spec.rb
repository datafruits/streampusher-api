require 'rails_helper'

RSpec.describe HostApplication, type: :model do
  it "it tells you if the username is taken" do
    user = FactoryBot.create :user, username: "yoshibo"
    host_application = FactoryBot.build :host_application, username: "yoshibo"
    expect(host_application.valid?).to eq false
    expect(host_application.errors[:username]).to be_present
  end

  it "it tells you if the email is taken" do
    FactoryBot.create :user, email: "yoshibo@malboro.info"
    host_application = FactoryBot.build :host_application, email: "yoshibo@malboro.info"
    expect(host_application.valid?).to eq false
    expect(host_application.errors[:email]).to be_present
  end

  it "converts listener account to dj account" do
    user = FactoryBot.create :user, email: "yoshibo@malboro.info", role: "listener"
    host_application = FactoryBot.build :host_application, email: "yoshibo@malboro.info"
    expect(host_application.valid?).to eq true
    host_application.save!
    host_application.approve!
    expect(User.where(username: host_application.username, email: host_application.email, time_zone: host_application.time_zone, role: "listener dj").count).to eq 1
    expect(host_application.approved?).to eq true
  end

  it "approves the application" do
    host_application = FactoryBot.create :host_application
    host_application.approve!
    expect(User.where(username: host_application.username, email: host_application.email, time_zone: host_application.time_zone).count).to eq 1
    expect(host_application.approved?).to eq true
  end

  it "fixes the timezone" do
    host_application = FactoryBot.create :host_application, email: "yoshibo@malboro.info", time_zone: "Asia/Tokyo"
    expect(host_application.time_zone).to eq "Osaka"
  end
end
