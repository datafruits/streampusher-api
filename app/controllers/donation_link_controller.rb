class DonationLinkController < ApplicationController
  before_action :current_radio_required
  def create
    authorize! :update, :metadata
    if DonationLinkUpdater.perform @current_radio.name, donation_link_params[:url]
      head :ok
    else
      head :error
    end
  end

  private
  def donation_link_params
    params.require(:donation_link).permit(:url)
  end
end
