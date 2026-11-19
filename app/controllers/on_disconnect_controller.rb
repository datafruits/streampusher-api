class OnDisconnectController < ApplicationController
  include LiquidsoapAuthentication

  before_action :current_radio_required
  def create
    if liq_authorized?
      LiveDisconnect.perform @current_radio.name
      head :ok
    else
      render json: "not permitted", status: :unauthorized
    end
  end
end
