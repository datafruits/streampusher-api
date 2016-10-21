class ListensController < ApplicationController
  load_and_authorize_resource
  respond_to :json
  def index
    @listens = @current_radio.listens.group(:start_at).count
    render json: @listens
  end
end
