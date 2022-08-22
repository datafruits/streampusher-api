class VjController < ApplicationController
  def index
    authorize! :vj, :dashboard, params[:format]
    @radio = @current_radio
  end
  def enabled
    @radio = @current_radio
    response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
    render json: {vj_enabled: @radio.vj_enabled?}.to_json
  end
  def update
    authorize! :vj, :dashboard
    @radio = @current_radio
    @radio.attributes = update_params
    if @radio.save && VjUpdater.perform(@radio.vj_enabled, @radio.name)
      redirect_to vj_path
    else
      render 'index'
    end
  end

  private
  def update_params
    params.require(:radio).permit(:vj_enabled)
  end
end
