class LabelsController < ApplicationController
  load_and_authorize_resource
  before_action :current_radio_required, only: [:index, :show]
  def show
    @label = @current_radio.labels.find params[:id]
    render json: @label
  end

  def index
    @labels = @current_radio.labels.includes(:track_labels)
    response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
    render json: @labels
  end

  def create
    @label = @current_radio.labels.new label_params
    if @label.save
      render json: @label
    else
      render json: { errors: @label.errors }, status: :unprocessable_entity
    end
  end

  private
  def label_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :name
    ])
  end
end
