class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(update_params)
    else
      # remove the virtual current_password attribute, update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(update_params)
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      ActiveSupport::Notifications.instrument 'user.updated', current_user: current_user.email
      redirect_to radios_path
    else
      render "edit"
    end
  end

  def destroy
    resource.soft_delete
    ActiveSupport::Notifications.instrument 'user.canceled', current_user: current_user.email
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  private

  def create_params
    params.require(:signup_form).permit(:email, :password, :password_confirmation, :current_password, :time_zone,
                                 radios: [:name])
  end

  def update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :time_zone, :username)
  end
  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      !params[:user][:password].blank?
  end
end
