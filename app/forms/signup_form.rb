class SignupForm < ActiveForm::Base
  self.main_model = :user
  attributes :email, :password
  validates :email, :password, presence: true

  association :radios do
    attributes :name
  end

  association :subscription do
    attributes :plan_id, required: true
  end

  def save
    if valid?
      model.subscription.save_with_payment
      model.save
      true
    else
      false
    end
  end
end
