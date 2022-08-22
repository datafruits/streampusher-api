class LiquidsoapRequestsController < ApplicationController
  before_action :current_radio_required
  def index
    @liquidsoap = LiquidsoapRequests.new @current_radio.id
    @request_metadatas = @liquidsoap.request_metadatas(@liquidsoap.alive)
    @on_air = @liquidsoap.on_air

    render json: { request_metadatas: @request_metadatas, on_air: @on_air }
  end
end
