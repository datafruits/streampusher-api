class LiveNotificationController < ApplicationController
  include LiquidsoapAuthentication

  before_action :current_radio_required
  def create
    if liq_authorized?
      LiveNotification.perform @current_radio.name, params[:metadata]
      head :ok
    else
      render json: "not permitted", status: :unauthorized
    end
  end
end
