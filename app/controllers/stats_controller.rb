class StatsController < ApplicationController
  def index
    authorize! :index, :stats
  end
end
