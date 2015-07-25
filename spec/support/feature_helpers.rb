module FeatureHelpers
  def login_as user
    visit "/login"
    fill_in "user_login", with: user.email
    fill_in "user_password", with: "password"
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."
  end

  def select_date(date, options = {})
    field = options[:from]
    select date.year.to_s,   :from => "#{field}_1i"
    select date.strftime("%B"),       :from => "#{field}_2i"
    select date.day.to_s,    :from => "#{field}_3i"
    select date.hour,    :from => "#{field}_4i"
    select date.strftime("%M"),    :from => "#{field}_5i"
  end
end
