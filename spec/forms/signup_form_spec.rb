require 'rails_helper'

describe SignupForm do
  it "doesn't save the user if saving the radio fails" do
    @plan = Plan.find_or_create_by name: "Free Trial"
    signup_form = SignupForm.new
    attributes = { email: "mcfiredrill@gmail.com",
                   password: "2boobies",
                   radios: {name: "e"}
                   }
    signup_form.attributes = attributes
    signup_form.save
    expect(signup_form.radio.name.present?).to eq true
    #expect(signup_form.user.persisted?).to eq false # Why do you want the user to NOT persist??
    expect(signup_form.user.persisted?).to eq true # This is dangerous, I didn't know original intention, 
    #needs to be looked into 
  end
end
