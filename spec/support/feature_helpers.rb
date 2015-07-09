module FeatureHelpers
  def login_as user
    visit "/login"
    fill_in "user_login", with: user.email
    fill_in "user_password", with: "password"
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."
  end
end
