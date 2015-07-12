require 'rails_helper'

feature 'help pages' do
  let(:owner) { FactoryGirl.create :user, username: "owner", role: "owner" }
  let(:subscription) { FactoryGirl.create :subscription, user: owner }
  let(:dj) { FactoryGirl.create :user, username: "dj", role: "dj", email: "dj@gmail.com" }
  let(:radio) { FactoryGirl.create :radio, subscription: subscription }
  before do
    owner.radios << radio
    dj.radios << radio
    subscription.radios << radio
  end
  scenario 'logged in dj can view broadcasting help page' do
    login_as dj
    visit broadcasting_help_path
    expect(page).to have_content("BROADCASTING HELP")
  end
end
