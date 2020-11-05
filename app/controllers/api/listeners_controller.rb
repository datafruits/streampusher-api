class Api::ListenersController < ApplicationController
  before_action :current_radio_required

  def create
    @user = User.create user_params.merge(role: "listener", password_confirmation: user_params[:password])
    if @user.save
      ActiveSupport::Notifications.instrument 'listener.created', radio: @current_radio.name, username: @user.username
      render json: @user
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
