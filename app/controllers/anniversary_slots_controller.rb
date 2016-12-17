class AnniversarySlotsController < ApplicationController
  def create
    authorize! :create, :anniversary_slot
    @show = @current_radio.scheduled_shows.new show_params
    @show.dj = current_user
    @show.title = current_user.username
    @show.playlist = @current_radio.default_playlist
    if @show.save
      redirect_to anniversary_slots_path, notice: "You took the slot!"
    else
      redirect_to anniversary_slots_path, notice: "Error taking this slot!"
    end
  end

  def index
    authorize! :index, :anniversary_slot
    @slots = []
    start_time = Time.utc(2017,1,6).in_time_zone
    end_time = Time.utc(2017,1,9).in_time_zone
    hour = start_time
    while hour < end_time
      start_at = hour
      end_at = hour+30.minutes
      # binding.pry
      show = ScheduledShow.where(start_at: start_at, end_at: end_at).first
      if show
        @slots << show
      else
        @slots << ScheduledShow.new(start_at: start_at, end_at: end_at)
      end
      hour += 30.minutes
    end
  end

  def sign_up
    authorize! :sign_up, :anniversary_slot
    @dj = DjSignup.perform dj_params, @current_radio
    if @dj.persisted?
      sign_in :user, @dj
      redirect_to anniversary_slots_path, notice: "You have successfully signed up."
    else
      redirect_to "/users/sign_in", notice: "Sorry, there was an error signing up. Please check the form."
    end
  end

  def destroy
    @show = ScheduledShow.find(params[:id])
    unless @show.dj == current_user
      raise CanCan::AccessDenied.new
    end
    @show.destroy
    redirect_to anniversary_slots_path, notice: "Slot deleted!"
  end

  private
  def dj_params
    params.require(:user).permit(:email, :username, :password, :time_zone)
  end

  def show_params
    params.require(:show).permit(:start_at, :end_at)
  end
end
