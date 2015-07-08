class ShowsController < ApplicationController
  load_and_authorize_resource
  def index
    @shows = @current_radio.shows
    @show = Show.new

    respond_to do |format|
      format.html
      format.json { @shows }
    end
  end

  def edit
  end

  def update
    @show.attributes = create_params
    if @show.save
      redirect_to shows_path
    else
      @current_radio = current_radio
      render 'edit'
    end
  end

  def create
    if @show.save
      redirect_to shows_path
    else
      @shows = @current_radio.shows
      render 'index'
    end
  end

  private
  def create_params
    params.require(:show).permit(:title, :dj_id, :radio_id, :playlist_id, :image)
  end
end
