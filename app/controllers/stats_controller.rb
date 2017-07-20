class StatsController < ApplicationController
  def index
    authorize! :index, :stats
    @start_at = params[:start_at] || 7.days.ago
    @end_at = params[:end_at] || Time.now
    @listens = @current_radio.listens
      .where("start_at >= (?) AND end_at <= (?)", @start_at, @end_at)
      .select(:ip_address).distinct
    @listens_by_day = @listens.group_by_day(:start_at).count
    @listens_by_hour = @listens.group_by_hour(:start_at).count
  end
end
