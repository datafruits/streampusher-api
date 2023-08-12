class Api::ShowSeriesController < ApplicationController
  def index
    show_series = ShowSeries.where.not(status: "disabled").where.not(title: "GuestFruits")
    render json: show_series
  end

  def show
    show_series = ShowSeries.where.not(status: "disabled").friendly.find params[:id]
    render json: show_series, include: ['users', 'labels']
  end
end
