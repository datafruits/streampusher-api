class StatsController < ApplicationController
  def index
    authorize! :index, :stats
    @start_at = params[:start_at]
    @end_at = params[:end_at]
    @listens = @current_radio.listens
      .where("start_at >= (?) AND end_at <= (?)", @start_at, @end_at)
      .select(:ip_address).distinct
    @listens_by_day = @listens.group_by_day.count
    @listens_by_hour = @listens.group_by_hour.count
  end
end
