class RegistrationsController < Devise::RegistrationsController
  def new
    @signup_form = SignupForm.new(User.new)
  end
  def create
    SignupForm.submit
  end
end
