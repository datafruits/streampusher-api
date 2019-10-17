class PublishMetadataController < ApplicationController
  before_action :current_radio_required
  def create
    MetadataPublisher.perform @current_radio.name, params[:metadata]
    head :ok
  end
end
