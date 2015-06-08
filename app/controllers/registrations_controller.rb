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
        byebug
        format.html { render :new }
      end
    end
  end

  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(user_params)
    else
      # remove the virtual current_password attribute, update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(user_params)
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to radios_path
    else
      render "edit"
    end
  end

  private

  def create_new_form
    user = User.new
    @signup_form = SignupForm.new(User.new)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :time_zone,
                                 subscription_attributes: [:plan_id, :stripe_card_token,
                                 radios_attributes: [:name]])
  end
  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      !params[:user][:password].blank?
  end
end
