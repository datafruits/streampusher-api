class PasswordsController < Devise::PasswordsController
  respond_to :json

  def create
    user = User.find_by(email: user_params[:email])

    if user
      raw, hashed = Devise.token_generator.generate(User, :reset_password_token).first
      user.reset_password_token = hashed
      user.reset_password_sent_at = Time.now.utc
      user.save!

      AccountMailer.reset_password(user, raw).deliver_later
      render head: :ok
    else
      render status: :unprocessable_entity
    end
  end

  def update
    user = User.reset_password_by_token(user_params)
    if user.valid?
      render head: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.deep_transform_keys(&:underscore).require(:user).permit(
      :reset_password_token, :password, :password_confirmation, :email
    )
  end
end
