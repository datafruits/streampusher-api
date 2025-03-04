class PublishMetadataController < ApplicationController
  before_action :current_radio_required
  def create
    if liq_authorized?
      MetadataPublisher.perform @current_radio.name, params[:metadata]
      MetadataUpdate.perform(@current_radio, { title: params[:metadata] })
      CanonicalMetadataSync.perform(@current_radio.id, { title: params[:metadata] })
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
