class Api::MyShowsController < ApplicationController
  def index
    authorize! :index, :my_shows

    show_series = ShowSeries.joins("inner join show_series_hosts on show_series_hosts.user_id = #{current_user.id}")

    render json: show_series
  end

  def create
    show_series = ShowSeries.new my_show_params
    authorize! :create, ShowSeries
    if show_series.save
      render json: show_series
    else
      render json: { errors: show_series.errors }, status: 422
    end
  end

  private
  def my_show_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :description
    ])
  end
end
