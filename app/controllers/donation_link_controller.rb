class PublishMetadataController < ApplicationController
  before_action :current_radio_required
  def create
    if liq_authorized?
      DonationLinkUpdater.perform @current_radio.name, donation_link_params[:url]
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

  def donation_link_params
    params.require(:donation_link).permit(:url)
  end
end
