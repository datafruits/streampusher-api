class RegistrationsController < Devise::RegistrationsController
  before_action :create_new_form, only: [:new, :create]
  def new
  end
  def create
    @signup_form.submit user_params
    respond_to do |format|
      if @signup_form.save
        sign_in :user, @signup_form.model
        format.html { redirect_to radios_path, notice: "user #{@signup_form.email} was successfully created." }
      else
        format.html { render :new }
      end
    end
  end
  private
  def create_new_form
    user = User.new
    @signup_form = SignupForm.new(User.new)
  end
  def user_params
    params.require(:user).permit(:email, :password, radios_attributes: [:name], subscription_attributes: [:plan_id, :stripe_card_token])
  end
end
