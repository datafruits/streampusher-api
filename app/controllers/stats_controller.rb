class StatsController < ApplicationController
  def index
    authorize! :index, :stats
    @listens = @current_radio.listens.order("date_trunc('day',start_at) ASC").group("date_trunc('day', start_at)").count
  end
end
