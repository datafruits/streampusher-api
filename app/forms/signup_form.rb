class SignupForm < ActiveForm::Base
  self.main_model = :user
  attributes :email, :password
  validates :email, :password, presence: true

  association :radios do
    attributes :name
  end

  association :subscription do
    attributes :plan_id, :stripe_card_token, required: true
  end
end
