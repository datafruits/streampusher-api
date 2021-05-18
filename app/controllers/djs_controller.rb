class DjsController < ApplicationController
  def index
    authorize! :index, :dj
    @djs = @current_radio.djs.order("username DESC")
    if params[:search]
      @djs = @djs.where("username ilike (?)", "%#{params[:search].permit(:keyword)[:keyword]}%")
    end
    @djs = @djs.page(params[:page])
    respond_to do |format|
      format.html {
        @dj = @djs.new
      }
      format.json {
        response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
        meta = { page: params[:page], total_pages: @djs.total_pages.to_i }
        render json: @djs, meta: meta
      }
    end
  end

  def show
    authorize! :show, :dj
    djs = @current_radio.djs
      .includes([:scheduled_show_performers,
                 scheduled_shows: [ { performers: :links }, :radio, { tracks: [ :radio, :uploaded_by, :labels ] } ]])
    if params[:name].present?
      @dj = djs.find_by(username: params[:name])
    else
      @dj = djs.find(params[:id])
    end
    respond_to do |format|
      format.html
      format.json {
        response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
        render json: @dj, serializer: DjWithRelationshipsSerializer, root: "dj"
      }
    end
  end

  def create
    authorize! :create, :dj
    begin
      @dj = DjSignup.perform dj_params, @current_radio
      if @dj.persisted?
        respond_to do |format|
          format.html {
            flash[:notice] = "Created DJ account for #{@dj.email}"
            redirect_to djs_path
          }
          format.json {
            render json: @dj
          }
        end
      else
        respond_to do |format|
          format.html {
            flash[:error] = "Error saving this DJ account"
            @djs = @current_radio.djs.page(params[:page])
            render 'index'
          }
          format.json {
            render json: @dj.errors, status: :unprocessable_entity
          }
        end
      end
    rescue ExistingUserRadio => e
      respond_to do |format|
        format.html {
          flash[:error] = "User already exists on this radio."
          @djs = @current_radio.djs.page(params[:page])
          @dj = @djs.new
          render 'index'
        }
        format.json {
          render json: @dj.errors, status: :unprocessable_entity
        }
      end
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
      respond_to do |format|
        format.html {
          flash[:notice] = "Updated dj account."
          @djs = @current_radio.djs.page(params[:page])
          redirect_to djs_path
        }
        format.json {
          render json: @dj
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Couldn't update dj account"
          @djs = @current_radio.djs.page(params[:page])
          render 'edit'
        }
        format.json {
          render json: @dj.errors, status: :unprocessable_entity
        }
      end
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
