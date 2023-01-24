class Api::MyShowsController < ApplicationController
  def index
    authorize! :index, :my_shows

    show_series = ShowSeries.joins("inner join show_series_hosts on show_series_hosts.user_id = #{current_user.id}")

    render json: show_series
  end
end
