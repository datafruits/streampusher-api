class ListensController < ApplicationController
  load_and_authorize_resource
  respond_to :json
  def index
    @listens = @current_radio.listens.group("date_trunc('day',start_at)").order("count_all ASC").count
    render json: @listens
  end
end
