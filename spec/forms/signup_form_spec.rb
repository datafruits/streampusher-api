require 'rails_helper'

describe SignupForm do
  it "doesn't save the user if saving the radio fails" do
    @plan = Plan.find_or_create_by name: "Free Trial"
    signup_form = SignupForm.new
    attributes = { email: "mcfiredrill@gmail.com",
                   password: "2boobies",
                   subscription: { plan_id: @plan.id,
                                   radios: { name: ""}
                   }
    }
    signup_form.attributes = attributes
    signup_form.save
    expect(signup_form.radio.errors[:name].present?).to eq true
    expect(signup_form.user.persisted?).to eq false
  end
end
