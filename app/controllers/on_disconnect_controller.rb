class OnDisconnectController < ApplicationController
  before_action :current_radio_required
  def create
    if liq_authorized?
      LiveDisconnect.perform @current_radio.name
      head :ok
    else
      render json: "not permitted", status: :unauthorized
    end
  end

  private

  def liq_authorized?
    liq_secret = request.headers["liq-secret"]
    return liq_secret == Rails.application.secrets.liq_secret
  end
end
