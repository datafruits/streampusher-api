require 'rails_helper'

feature 'signup' do
  scenario 'user subscribes' do
    visit '/users/sign_up'

    fill_in :email, with: 'steve.aoki@gmail.com'
    fill_in :password, with: 'stevespassword'
    fill_in :radio_name, with: 'BLOCKFM'

    fill_in 'card_number', with: 4242424242424242
    fill_in 'cvv', with: 4242
    fill_in 'cardholder_name', with: 'Steve Aoki'
    fill_in 'expiration', with: "04#{1.year.from_now.year}"

    click_button 'Sign up now'
  end
end
