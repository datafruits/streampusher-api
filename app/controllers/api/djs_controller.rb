class Api::DjsController < ApplicationController
  serialization_scope :serializer_scope

  def index
    @djs = @current_radio.active_djs.unscoped.order("username ASC")
    if params[:search]
      @djs = @djs.where("username ilike (?)", "%#{params[:search].permit(:keyword)[:keyword]}%")
    end
    if params[:published]
      @djs = @djs.where(profile_publish: true)
    end

    if params[:tags]
      for tag in params[:tags].split(",")
        @djs = @djs.where("role ilike (?)", "%#{tag}%")
      end
    end
    
    options = {}
    options[:meta] = { page: params[:page], total_pages: @djs.page.total_pages.to_i }
    render json: Fast::DjSerializer.new(@djs, options).serializable_hash.to_json
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
