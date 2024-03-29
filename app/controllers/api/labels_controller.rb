class Api::LabelsController < ApplicationController
  def index
    labels = @current_radio.labels
    if params[:term]
      labels = labels.where("name ilike (?)", "%#{params.permit(:term)[:term]}%")
    end
    render json: Fast::LabelSerializer.new(labels).serializable_hash.to_json
  end
end
