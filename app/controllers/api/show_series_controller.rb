class Api::ShowSeriesController < ApplicationController
  def index
    show_series = ShowSeries.where.not(status: "disabled").order("title ASC")
    render json: show_series, include: ['users', 'labels']

  end

  def show
    show_series = ShowSeries.where.not(status: "disabled").friendly.find params[:id]
    render json: show_series, include: ['users', 'labels']
  end
end
