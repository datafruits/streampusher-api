class ListensController < ApplicationController
  load_and_authorize_resource
  respond_to :json

  def index
    @start_at = params[:start_at]
    @end_at = params[:end_at]
    @listens = @current_radio.listens
      .where("start_at >= (?) AND end_at <= (?)", @start_at, @end_at)
      .select(:ip_address).distinct.group_by_day.count
    render json: @listens
  end
end
