class PasswordsController < Devise::PasswordsController
  respond_to :json

  def create
    user = User.find_by(email: params[:email])

    if (user)
      AccountMailer.reset_password(user).deliver_later
      render head: :ok
    else
      render status: :unprocessable_entity
    end
  end
end
