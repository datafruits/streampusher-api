class MetadataController < ApplicationController
  def create
    authorize! :update, :metadata
    if MetadataUpdate.perform(@current_radio, metadata_params)
      MetadataPublisher.perform @current_radio.name, metadata_params[:title]
      flash[:notice] = "Updated!"
      render 'create'
    else
      flash[:error] = "Sorry, there was an error..."
      render 'error'
    end
  end

  private
  def metadata_params
    params.require(:metadata).permit(:title)
  end
end
