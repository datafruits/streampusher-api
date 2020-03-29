class LiquidsoapRequestsController < ApplicationController
  before_action :current_radio_required
  def index
    @requests = LiquidsoapRequests.alive @current_radio
    @on_air = LiquidsoapRequests.on_air @current_radio
  end
end
