class ShowsController < ApplicationController
  load_and_authorize_resource
  def index
    @current_radio = current_radio
    @shows = @current_radio.shows
    @show = @shows.new

    respond_to do |format|
      format.html
      format.json { @shows }
    end
  end

  def create
    if @show.save
      redirect_to shows_path
    else
      @current_radio = current_radio
      @shows = @current_radio.shows
      render 'index'
    end
  end

  private
  def create_params
    params.require(:show).permit(:dj_id, :title, :start_at, :end_at, :radio_id)
  end
end
