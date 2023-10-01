class Api::LabelsController < ApplicationController
  def index
    @labels = @current_radio.labels.includes(:track_labels)
    if params[:term]
      @labels = @labels.where("name ilike (?)", "%#{params.permit(:term)[:term]}%")
    end
    render json: @labels
  end
end
