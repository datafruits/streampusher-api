class Djs::DisablesController < ApplicationController
  def create
    authorize! :manage, :dj
    @dj = @current_radio.djs.find(params[:id])
    @dj.update! enabled: false
    render json: :ok
  end

  def destroy
    authorize! :manage, :dj
    @dj = @current_radio.djs.find(params[:id])
    @dj.update! enabled: true
    render json: :ok
  end
end
