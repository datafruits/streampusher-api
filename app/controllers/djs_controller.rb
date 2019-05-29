class DjsController < ApplicationController
  def index
    authorize! :index, :dj
    @djs = @current_radio.djs
    if params[:search]
      @djs = @djs.where("username ilike (?)", "%#{params[:search].permit(:keyword)[:keyword]}%")
    end
    respond_to do |format|
      format.html {
        @djs = @djs.page(params[:page])
        @dj = @djs.new
      }
      format.json {
        @djs = @current_radio.active_djs
        response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
        render json: @djs.includes([:scheduled_show_performers,
                                    scheduled_shows: [ { performers: :links }, :radio, { tracks: [ :radio, :uploaded_by ] } ]]),
          each_serializer: DjSerializer
      }
    end
  end

  def show
    authorize! :show, :dj
    @dj = @current_radio.djs
      .includes([:scheduled_show_performers,
                 scheduled_shows: [ { performers: :links }, :radio, { tracks: [ :radio, :uploaded_by, :labels ] } ]])
      .find_by(username: params[:id])
    respond_to do |format|
      format.html
      format.json {
        response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
        render json: @dj, serializer: DjSerializer
      }
    end
  end

  def create
    authorize! :create, :dj
    begin
      @dj = DjSignup.perform dj_params, @current_radio
      if @dj.persisted?
        flash[:notice] = "Created DJ account for #{@dj.email}"
        redirect_to djs_path
      else
        flash[:error] = "Error saving this DJ account"
        @djs = @current_radio.djs.page(params[:page])
        render 'index'
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
    @dj = @current_radio.djs.find(params[:id])
    @dj.attributes = dj_params
    if @dj.save
      flash[:notice] = "Updated dj account."
      redirect_to dj_path(@dj.username)
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
    params.require(:user).permit(:email, :username, :time_zone, :image, :bio, :role, :profile_publish)
  end
end
