class Api::DjsController < ApplicationController
  def index
    @djs = @current_radio.djs.order("username DESC")
    if params[:search]
      @djs = @djs.where("username ilike (?)", "%#{params[:search].permit(:keyword)[:keyword]}%")
    end
    @djs = @current_radio.active_djs
    render json: @djs, each_serializer: DjSerializer
  end

  def show
    djs = @current_radio.djs
      .includes([:scheduled_show_performers,
                 scheduled_shows: [ { performers: :links }, :radio, { tracks: [ :radio, :uploaded_by, :labels ] } ]])
    if params[:name].present?
      @dj = djs.find_by(username: params[:name])
    else
      @dj = djs.find(params[:id])
    end
    render json: @dj, serializer: DjWithRelationshipsSerializer, root: "dj"
  end
end
