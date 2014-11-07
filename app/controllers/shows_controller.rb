class ShowsController < ApplicationController
  load_and_authorize_resource
  def index
    @current_radio = current_radio
    @shows = @current_radio.shows
    @show = @shows.new
  end

  def create
  end

  private
  def create_params

  end
end
