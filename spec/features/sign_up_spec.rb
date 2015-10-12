require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

def visit_sign_up_page
  visit "/users/sign_up"
end

def fill_in_sign_up_form_with email, password, radio_name
  fill_in "signup_form[email]", with: email
  fill_in "signup_form[password]", with: password
  fill_in "signup_form[subscription][radios][name]", with: radio_name
end

def click_sign_up_button
  click_button "Sign up now"
end

def i_should_see_i_signed_up_as username
  expect(page).to have_content "You have successfully signed up."
  expect(page).to have_content username
end

def visit_dashboard
  visit "/"
end

def click_subscription_link
  click_link "steve.aoki"
  click_link "Subscription"
end

feature 'signup' do
  scenario 'user subscribes' do
    VCR.use_cassette "user_sign_up" do
      visit_sign_up_page
      fill_in_sign_up_form_with "steve.aoki@gmail.com", "stevespassword", "BLOCKFM"
      click_sign_up_button

      i_should_see_i_signed_up_as "steve.aoki"
    end
  end

  scenario 'form shows error if no email' do
    VCR.use_cassette "user_sign_up_no_email" do
      visit_sign_up_page
      fill_in_sign_up_form_with "", "stevespassword", "BLOCKFM"
      click_sign_up_button

      expect(page).to have_content "Email can't be blank"
    end
  end

  scenario 'form shows error if no password'

  scenario 'form shows error if no radio name'

  scenario 'free trial expires after 30 days' do
    VCR.use_cassette "user_sign_up" do
      visit_sign_up_page
      fill_in_sign_up_form_with "steve.aoki@gmail.com", "stevespassword", "BLOCKFM"
      click_sign_up_button

      i_should_see_i_signed_up_as "steve.aoki"
    end
    Timecop.travel 30.days.from_now do
      visit_dashboard
      expect(page).to have_content("Free trial has expired.")
    end
  end

  scenario 'can switch to a paid plan' do
    VCR.use_cassette "user_sign_up" do
      visit_sign_up_page
      fill_in_sign_up_form_with "steve.aoki@gmail.com", "stevespassword", "BLOCKFM"
      click_sign_up_button

      i_should_see_i_signed_up_as "steve.aoki"
    end
    click_subscription_link
    expect(page).to have_content "You are currently subscribed to the Free Trial plan"
    select_basic_plan
    enter_credit_card_info
    click_purchase_link
    expect(page).to have_content "Signed up for the basic plan!"
    expect(page).to have_content "You are currently subscribed to the Basic plan"
  end
end
