class Api::TreasureChestsController < ApplicationController
  def create
    authorize! :create, TreasureChest
    user = User.find_by username: treasure_chest_params[:username]
    treasure_chest = TreasureChest.new
    treasure_chest.user = user
    treasure_chest.attributes = treasure_chest_params.except(:username)
    if treasure_chest.save
      ActiveSupport::Notifications.instrument 'treasure_chest.opened'
      render json: treasure_chest
    else
      ActiveSupport::Notifications.instrument 'treasure_chest.open.error'
      render json: { errors: treasure_chest.errors }, status: 422
    end
  end

  private
  def treasure_chest_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :treasure_name, :amount, :username, :treasure_uid
    ])
  end
end
