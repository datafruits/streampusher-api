class DjsController < ApplicationController
  def index
    authorize! :index, :dj
    @djs = @current_radio.djs.order("username DESC")
    if params[:search]
      @djs = @djs.where("username ilike (?)", "%#{params[:search].permit(:keyword)[:keyword]}%")
    end
    @djs = @djs.page(params[:page])
    response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
    meta = { page: params[:page], total_pages: @djs.total_pages.to_i }
    render json: @djs, meta: meta
  end

  def show
    authorize! :show, :dj
    djs = @current_radio.djs
      .includes([:scheduled_show_performers,
                 scheduled_shows: [ :performers, :radio, { tracks: [ :radio, :uploaded_by, :labels ] } ]])
    if params[:name].present?
      @dj = djs.find_by(username: params[:name])
    else
      @dj = djs.find(params[:id])
    end
    response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
    render json: @dj, serializer: DjSerializer, root: "dj"
  end

  def create
    authorize! :create, :dj
    begin
      @dj = DjSignup.perform dj_params, @current_radio
      if @dj.persisted?
        render json: @dj
      else
        respond_with_errors(@dj)
      end
    rescue ExistingUserRadio => e
      respond_with_errors(@dj)
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
      render json: @dj
    else
      respond_with_errors(@dj)
    end
  end

  def destroy
    authorize! :destroy, :dj
  end

  private
  def dj_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :email, :username, :time_zone, :image, :bio, :role, :profile_publish
    ])
  end
end
