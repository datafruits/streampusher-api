require 'rails_helper'

def visit_subscription_edit_path subscription
  visit edit_subscription_path subscription
end

def select_paid_plan
  select "Hobbyist", from: "subscription_plan_id"
end

def add_card_details
  fill_in "card_number", with: "4242424242424242"
  fill_in "card_code", with: "123"
  fill_in "name", with: "Steve Aoki"
  fill_in "card_exp", with: "12/99"
end

def click_update_button
  click_button "Update"
end

def i_should_see_my_plan_updated
  expect(page).to have_content("You are currently subscribed to the Hobbyist plan")
end

feature 'subscriptions' do
  let(:owner) { FactoryGirl.create :user, username: "owner", role: "owner" }
  let!(:subscription) { FactoryGirl.create :subscription, user: owner }
  it 'upgrades from a free trial to a paid plan' do
    login_as owner
    visit_subscription_edit_path subscription
    select_paid_plan
    add_card_details
    click_update_button
    i_should_see_my_plan_updated
  end
  it 'emails the user when their free trial is about to end'
end
