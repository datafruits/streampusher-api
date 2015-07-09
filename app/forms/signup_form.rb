class SignupForm < ActionForm::Base
  self.main_model = :user
  attributes :email, :password
  validates :email, :password, presence: true

  association :subscription do
    attributes :plan_id, required: true
    association :radios, records: 1 do
      attributes :name
    end
  end

  def submit params
    self.model.role = "owner"
    super(params)
  end

  def save
    super
    self.model.subscription.save_with_free_trial
    self.model.radios << self.model.subscription.radios.first
    UserSignedUpNotifier.notify self
  end
end
