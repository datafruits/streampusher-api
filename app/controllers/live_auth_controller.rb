class LiveAuthController < ApplicationController
  before_action :current_radio_required

  def create
    if !liq_authorized?
      render json: "not permitted", status: :unauthorized
    elsif @current_radio.current_scheduled_show.present?
      render json: "not permitted", status: :unauthorized
    elsif valid_user?
      head :ok
    else
      render json: "not permitted", status: :unauthorized
    end
  end

  private

  def liq_authorized?
    liq_secret = request.headers["liq-secret"]
    liq_secret == Rails.application.secrets.liq_secret
  end

  def valid_user?
    user = User.find_for_database_authentication(login: params[:user])
    user.present? && user.valid_password?(params[:password])
  end
end
