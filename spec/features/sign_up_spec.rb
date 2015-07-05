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
  fill_in "user[email]", with: email
  fill_in "user[password]", with: password
  fill_in "user[subscription_attributes][radios_attributes][0][name]", with: radio_name
end

def click_sign_up_button
  click_button "Sign up now"
end

def i_should_see_i_signed_up_as username
  expect(page).to have_content "You have successfully signed up."
  expect(page).to have_content username
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
end
