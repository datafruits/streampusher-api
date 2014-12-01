class SignupForm < ActiveForm::Base
  self.main_model = :user
  attributes :email, :password
  validates :email, :password, presence: true

  association :subscription do
    attributes :plan_id, :stripe_card_token, required: true
    association :radios, records: 1 do
      attributes :name
    end
  end
end
