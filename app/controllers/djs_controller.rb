class DjsController < ApplicationController
  def index
    authorize! :index, :dj
    @djs = @current_radio.djs.page(params[:page])
    @dj = @djs.new
  end

  def create
    authorize! :create, :dj
    begin
      @dj = DjSignup.perform dj_params, @current_radio
      if @dj.persisted?
        flash[:notice] = "Created DJ account for #{@dj.email}"
        redirect_to djs_path
      end
    rescue ExistingUserRadio => e
      flash[:error] = "User already exists on this radio."
      # flash[:error] = "Couldn't create dj account"
      @djs = @current_radio.djs.page(params[:page])
      @dj = @djs.new
      render 'index'
    end
  end

  def edit
    authorize! :edit, :dj
    @dj = @current_radio.djs.find(params[:id])
  end

  def update
    authorize! :update, :dj
    @dj.attributes = dj_params
    if @dj.save
      flash[:notice] = "Updated dj account."
      redirect_to djs_path
    else
      flash[:error] = "Couldn't update dj account"
      @djs = @current_radio.djs.page(params[:page])
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, :dj
  end

  private
  def dj_params
    params.require(:user).permit(:email, :username, :time_zone)
  end
end
