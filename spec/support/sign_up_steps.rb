module SignUpSteps
  def visit_sign_up_page
    visit '/users/sign_up'
  end

  def fill_in_sign_up_form_with user, password, radio_name
    fill_in "#user_email", with: user
    fill_in "#user_password", with: password
    fill_in "#user_subscription_attributes_radios_attributes_0_name", with: radio_name
  end

  def click_sign_up_button
    click_button "Sign up now"
  end

  def i_should_see_i_signed_up_as
    expect(page).to have_content "You have successfully signed up."
  end
end
