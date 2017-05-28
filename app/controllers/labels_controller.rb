class LabelsController < ApplicationController
  load_and_authorize_resource
  def show
    @label = @current_radio.labels.find params[:id]
    render json: @label
  end

  def index
    @labels = @current_radio.labels
    render json: @labels
  end

  def create
    @label = @current_radio.labels.new label_params
    if @label.save
      render json: @label
    else
      render json: @label.errors
    end
  end

  private
  def label_params
    params.require(:label).permit(:name)
  end
end
