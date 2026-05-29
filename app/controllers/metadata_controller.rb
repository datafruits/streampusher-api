class MetadataController < ApplicationController
  def create
    authorize! :update, :metadata
    if LiquidsoapMetadataUpdate.perform(@current_radio, metadata_params)
      RedisMetadataPublisher.perform @current_radio.name, metadata_params[:title]
      head :ok
    else
      head :error
    end
  end

  private
  def metadata_params
    params.require(:metadata).permit(:title)
  end
end
