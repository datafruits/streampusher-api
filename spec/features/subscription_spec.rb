require 'rails_helper'

feature 'subscriptions' do
  let(:owner) { FactoryGirl.create :user, username: "owner", role: "owner" }
  let!(:subscription) { FactoryGirl.create :subscription, user: owner }
  it 'emails the user when their free trial is about to end'
end
