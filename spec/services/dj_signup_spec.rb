require 'rails_helper'

describe DjSignup do
  it "creates a new user account and adds to the radio" do
    radio = FactoryGirl.create :radio
    email = "mcfiredrill@gmail.com"
    username = "freedrool"
    user_params = {email: email, username: username}
    DjSignup.perform user_params, radio
    user = User.find_by_email(email)
    expect(user.radios).to include(radio)
  end

  it "adds user radio to account if it already exists" do
    radio = FactoryGirl.create :radio
    radio2 = FactoryGirl.create :radio, name: 'daddyboots', subscription: radio.subscription
    email = "mcfiredrill@gmail.com"
    username = "freedrool"
    user_params = {email: email, username: username}
    DjSignup.perform user_params, radio
    DjSignup.perform user_params, radio2
    expect(User.where(email: email).count).to eq 1
    user = User.find_by_email(email)
    expect(user.radios).to include(radio)
    expect(user.radios).to include(radio2)
  end

  it "returns error if this user already belongs to this radio" do
    radio = FactoryGirl.create :radio
    radio2 = FactoryGirl.create :radio, name: 'daddyboots', subscription: radio.subscription
    email = "mcfiredrill@gmail.com"
    username = "freedrool"
    user_params = {email: email, username: username}
    DjSignup.perform user_params, radio
    DjSignup.perform user_params, radio2
    expect(User.where(email: email).count).to eq 1
    user = User.find_by_email(email)
    expect(user.radios).to include(radio)
    expect(user.radios).to include(radio2)

    expect do
      DjSignup.perform user_params, radio2
    end.to raise_error ExistingUserRadio
  end
end
