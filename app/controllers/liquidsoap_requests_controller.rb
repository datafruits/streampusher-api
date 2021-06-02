class LiquidsoapRequestsController < ApplicationController
  before_action :current_radio_required
  def index
    @liquidsoap = LiquidsoapRequests.new @current_radio.id
    @requests = @liquidsoap.alive
    @on_air = @liquidsoap.on_air
  end
end
