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
      ActiveSupport::Notifications.instrument 'show.created', current_user: current_user.email, radio: @current_radio.name, show: @show.title
      flash[:notice] = "Successfully created show."
      redirect_to shows_path
    else
      flash[:error] = "There was an error saving this show."
      @shows = @current_radio.shows
      render 'index'
    end
  end

  def destroy
    @show.destroy
    flash[:notice] = "Deleted show!"
    redirect_to shows_path
  end

  private
  def create_params
    params.require(:show).permit(:title, :dj_id, :radio_id, :playlist_id, :image)
  end
end
