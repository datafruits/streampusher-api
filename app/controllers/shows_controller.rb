class ShowsController < ApplicationController
  def index
    @current_radio = current_radio
    @shows = @current_radio.shows
    @show = @shows.new
  end
end
