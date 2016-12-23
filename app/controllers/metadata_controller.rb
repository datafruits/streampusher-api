class MetadataController < ApplicationController
  def create
    authorize! :update, :metadata
    render json: MetadataUpdate.perform(@current_radio, metadata_params)
  end

  private
  def metadata_params
    params.require(:metadata).permit(:title)
  end
end
