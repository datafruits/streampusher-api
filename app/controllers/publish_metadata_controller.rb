class PublishMetadataController < ApplicationController
  def create
    MetadataPublisher.perform params[:metadata]
    head :ok
  end
end
