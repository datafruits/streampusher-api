class PublishMetadataController < ApplicationController
  include LiquidsoapAuthentication

  before_action :current_radio_required
  def create
    if liq_authorized?
      RedisMetadataPublisher.perform @current_radio.name, params[:metadata]
      LiquidsoapMetadataUpdate.perform(@current_radio, { title: params[:metadata] })
      CanonicalMetadataSync.perform(@current_radio.id, params[:metadata] )
      head :ok
    else
      render json: "not permitted", status: :unauthorized
    end
  end
end
