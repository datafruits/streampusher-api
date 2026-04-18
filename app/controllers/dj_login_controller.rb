class DjLoginController < ApplicationController
  before_action :current_radio_required

  def create
    if liq_authorized?
      if params[:user].blank?
        return render json: { success: false }, status: :unauthorized
      end
      user = @current_radio.djs.find_by("lower(username) = ?", params[:user].downcase)
      if user.present? && user.valid_password?(params[:password])
        render json: { success: true, username: user.username }
      else
        render json: { success: false }, status: :unauthorized
      end
    else
      render json: { success: false, error: "not permitted" }, status: :unauthorized
    end
  end

  private

  def liq_authorized?
    liq_secret = request.headers["liq-secret"]
    liq_secret == Rails.application.secrets.liq_secret
  end
end
