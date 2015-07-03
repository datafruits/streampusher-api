class ScheduledShowsController < ApplicationController
  load_and_authorize_resource
  def index
    setup_index

    respond_to do |format|
      format.html
      format.json {
        response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
        render json: @scheduled_shows, root: false
      }
    end
  end

  def create
    if @scheduled_show.save
      redirect_to scheduled_shows_path
    else
      setup_index
      render 'index'
    end
  end

  private
  def setup_index
    @current_radio = current_radio
    @scheduled_shows = @current_radio.scheduled_shows
    @shows = @current_radio.shows
  end

  def create_params
    params.require(:scheduled_show).permit(:title, :radio_id, :show_id, :start_at, :end_at)
  end
end
