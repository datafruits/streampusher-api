class PublishMetadataController < ApplicationController
  before_action :current_radio_required
  def create
    if liq_authorized?
      render json: "not permitted", status: :unauthorized
    else
      MetadataPublisher.perform @current_radio.name, params[:metadata]
      head :ok
    end
  end

  private

  def liq_authorized?
    liq_secret = request.headers["liq-secret"]
    return liq_secret == Rails.application.secrets.liq_secret
  end
end
