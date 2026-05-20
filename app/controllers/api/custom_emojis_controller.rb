class Api::CustomEmojisController < ApplicationController
  before_action :authenticate_user!

  def create
    unless current_user.can_create_custom_emoji?
      render json: { error: "forbidden" }, status: :forbidden and return
    end

    @custom_emoji = current_user.custom_emojis.new(custom_emoji_params)
    if @custom_emoji.save
      render json: @custom_emoji, status: :created
    else
      render json: { errors: @custom_emoji.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def custom_emoji_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :name, :image
    ])
  end
end
