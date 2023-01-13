require 'rails_helper'

describe DjSignup do
  it "creates a new user account and adds to the radio" do
    radio = FactoryBot.create :radio
    email = "mcfiredrill@gmail.com"
    username = "freedrool"
    user_params = {email: email, username: username}
    DjSignup.perform user_params, radio
    user = User.find_by_email(email)
    expect(user.radios).to include(radio)
  end

  it "adds user radio to account if it already exists" do
    radio = FactoryBot.create :radio
    radio2 = FactoryBot.create :radio, name: 'daddyboots'
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

  it "returns error if this user already belongs to this radio with a dj role" do
    radio = FactoryBot.create :radio
    radio2 = FactoryBot.create :radio, name: 'daddyboots'
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

  it "adds the dj role if the user already exists on this radio without dj role" do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user
    user.user_radios.create(radio: radio)
    user.add_role "listener"
    user.save!
    user_params = {email: user.email, username: user.username}
    DjSignup.perform user_params, radio

    expect(User.where(email: user.email).count).to eq 1
    user = User.find_by_email(user.email)
    expect(user.radios).to include(radio)
    expect(user.roles).to include("dj")
  end
end
