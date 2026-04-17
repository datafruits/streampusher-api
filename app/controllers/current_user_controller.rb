class CurrentUserController < ApplicationController
  def index
    authorize! :index, :current_user
    user = current_user

    render json: user, serializer: UserSerializer, include: 'scheduled_show_favorites'
  end

  def update
    authorize! :update, :current_user
    user = current_user
    update_params = user_params
    user.attributes = update_params
    if user.save
      render json: user, serializer: UserSerializer
    else
      respond_with_errors user
    end
  end

  private
  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :style, :avatar, :pronouns, :bio, :homepage, :time_zone, :username
    ])
  end
end
