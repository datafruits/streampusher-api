class Api::FruitSummonsController < ApplicationController
  before_action :current_radio_required

  def create
    logger.info fruit_summon_params
    logger.info fruit_summon_params[:name].gsub(/-/, '_')
    fruit_summon = FruitSummonTransaction.perform fruit_summon_params[:name].gsub(/-/, '_'), current_user
    render json: fruit_summon
  end

  private
  def fruit_summon_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :name])
  end
end
