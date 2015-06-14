require 'rails_helper'

feature 'signup' do
  scenario 'user subscribes' do
    visit_sign_up_page
    fill_in_sign_up_form_with "steve.aoki@gmail.com", "stevespassword", "BLOCKFM"
    click_sign_up_button

    i_should_see_i_signed_up_as "steve.aoki@gmail.com"
  end
end
