class ListensController < ApplicationController
  load_and_authorize_resource
  respond_to :json
  def index
    @listens = @current_radio.listens.order("date_trunc('day',start_at) ASC").group("date_trunc('day', start_at)").count
    render json: @listens
  end
end
