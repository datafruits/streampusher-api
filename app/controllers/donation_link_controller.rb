class DonationLinkController < ApplicationController
  before_action :current_radio_required
  def create
    authorize! :update, :metadata
    if DonationLinkUpdater.perform @current_radio.name, donation_link_params[:url]
      flash[:notice] = "Updated!"
      render 'create'
    else
      flash[:error] = "Sorry, there was an error..."
      render 'error'
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
