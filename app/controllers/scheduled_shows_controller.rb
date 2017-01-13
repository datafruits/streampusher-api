class ScheduledShowsController < ApplicationController
  load_and_authorize_resource
  def new

  end

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

  def show
    respond_to do |format|
      format.html
      format.json {
        response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
        render json: @scheduled_show, root: false
      }
    end
  end

  def next
    @scheduled_show = @current_radio.next_scheduled_show
    respond_to do |format|
      format.json {
        response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
        render json: @scheduled_show, root: false
      }
    end
  end

  def create
    @scheduled_show.dj_id = current_user.id
    if @scheduled_show.save
      ActiveSupport::Notifications.instrument 'scheduled_show.created', current_user: current_user.email, radio: @current_radio.name, show: @scheduled_show.title
      flash[:notice] = "Scheduled show!"
      redirect_to_with_js scheduled_shows_path
    else
      # setup_index
      flash[:error] = "Error scheduling show."
      render 'new'
    end
  end

  def update
    @scheduled_show.attributes = create_params
    if @scheduled_show.save
      flash[:notice] = "Updated scheduled show!"
      redirect_to_with_js scheduled_shows_path
    else
      flash[:error] = "Error updating scheduling show."
      render 'edit'
    end
  end

  def destroy
    @scheduled_show.destroy_recurrences = params[:destroy_recurrences]
    @scheduled_show.destroy
    flash[:notice] = "Deleted scheduled show!"
    redirect_to scheduled_shows_path
  end

  private
  def setup_index
    @scheduled_shows = @current_radio.scheduled_shows.where("start_at >= ? AND end_at <= ?", params[:start], params[:end]).order("start_at ASC")
    @scheduled_show = ScheduledShow.new
  end

  def create_params
    params.require(:scheduled_show).permit(:title, :radio_id, :start_at,
                                           :end_at, :description, :image, :update_all_recurrences,
                                           :recurring_interval, :playlist_id, :time_zone)
  end
end
