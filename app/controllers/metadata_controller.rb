class MetadataController < ApplicationController
  def update
    @radio = Radio.find_by_name(params[:id])
    render json: MetadataUpdate.perform(@radio, params[:metadata])
  end
end
