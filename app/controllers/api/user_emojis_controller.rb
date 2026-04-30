class Api::UserEmojisController < ApplicationController
  before_action :authenticate_user!

  def create
    @user_emoji = current_user.user_emojis.new(user_emoji_params)
    if @user_emoji.save
      render json: @user_emoji, status: :created
    else
      render json: { errors: @user_emoji.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_emoji_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :name, :image
    ])
  end
end
