class Api::DjsController < ApplicationController
  serialization_scope :serializer_scope

  def index
    @djs = @current_radio.djs.order("username DESC")
    if params[:search]
      @djs = @djs.where("username ilike (?)", "%#{params[:search].permit(:keyword)[:keyword]}%")
    end
    @djs = @current_radio.active_djs
    render json: @djs
  end

  def show
    djs = @current_radio.djs
      .includes([:scheduled_show_performers,
                 scheduled_shows: [ :performers, :radio, { tracks: [ :radio, :uploaded_by, :labels ] } ]]).where(enabled: true)
    if params[:name].present?
      @dj = djs.find_by(username: params[:name])
    else
      @dj = djs.find(params[:id])
    end
    if @dj
      render json: @dj, serializer: DjSerializer, root: "dj"
    else
      render json: { "error": "not found" } , status: 404
    end
  end

  private

  def serializer_scope
    {
      scheduled_shows: {
        page: params[:page]
      }
    }
  end
end
