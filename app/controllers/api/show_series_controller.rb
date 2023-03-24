class Api::ShowSeriesController < ApplicationController
  def index
    show_series = ShowSeries.all
    render json: show_series
  end
  def show
    show_series = ShowSeries.friendly.find params[:id]
    render json: show_series
  end
end
