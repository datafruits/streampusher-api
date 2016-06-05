require 'rails_helper'

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

def select_basic_plan
  select "Hobbyist", from: "subscription_plan_id"
end

def enter_credit_card_info
  "4242424242424242".split('').each { |c| find_field('card_number').native.send_keys(c) } # https://github.com/stripe/jquery.payment/issues/149#issuecomment-75344077
  fill_in "card_code", with: "123"
  fill_in "name", with: "Steve Aoki"
  "1229".split('').each { |c| find_field('card_exp').native.send_keys(c) }
end

def click_purchase_link
  click_button "Update"
end

feature 'signup' do
  before do
    Plan.create name: "Free Trial"
    Plan.create name: "Hobbyist", price: 19.00
  end
  scenario 'user subscribes' do
    VCR.use_cassette "user_sign_up" do
      visit_sign_up_page
      fill_in_sign_up_form_with "steve.aoki@gmail.com", "stevespassword", "BLOCKFM"
      click_sign_up_button

      i_should_see_i_signed_up_as "BLOCKFM"
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

  it 'free trial expires after 14 days' do
    VCR.use_cassette "user_sign_up" do
      visit_sign_up_page
      fill_in_sign_up_form_with "steve.aoki@gmail.com", "stevespassword", "BLOCKFM"
      click_sign_up_button

      i_should_see_i_signed_up_as "BLOCKFM"
    end
    Timecop.travel 14.days.from_now do
      visit_dashboard
      expect(page).to have_content("Free trial has expired.")
    end
  end

  scenario 'can switch to a paid plan', :js => true do
    VCR.use_cassette "user_upgrade_plan" do
      visit_sign_up_page
      fill_in_sign_up_form_with "steve.aoki@gmail.com", "stevespassword", "BLOCKFM"
      click_sign_up_button
      i_should_see_i_signed_up_as "steve.aoki"

      click_subscription_link
      expect(page).to have_content "You are currently subscribed to the Free Trial plan"

      select_basic_plan
      enter_credit_card_info
      click_purchase_link

      expect(page).to have_content "Updated your subscription successfully."
      expect(page).to have_content "You are currently subscribed to the Hobbyist plan"
    end
  end
end
