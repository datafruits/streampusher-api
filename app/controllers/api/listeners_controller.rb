class Api::ListenersController < ApplicationController
  before_action :current_radio_required

  def create
    @user = User.create user_params.merge(role: "listener", password_confirmation: user_params[:password])
    if @user.save
      ActiveSupport::Notifications.instrument 'listener.created', radio: @current_radio.name, username: @user.username
      render json: @user
    else
      respond_with_errors(@user)
    end
  end

  def validate_email
    if User.exists? email: params[:email]
      render json: { valid: false }.to_json
    else
      render json: { valid: true }.to_json
    end
  end

  def validate_username
    if User.exists? username: params[:username]
      render json: { valid: false }.to_json
    else
      render json: { valid: true }.to_json
    end
  end

  private
  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :username, :email, :password])
  end
end
