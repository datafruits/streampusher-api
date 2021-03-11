class CurrentUserController < ApplicationController
  def index
    authorize! :index, :current_user
    user = current_user

    respond_to do |format|
      format.json {
        render json: user, serializer: UserSerializer
      }
    end
  end

  def update
    authorize! :update, :current_user
    user = current_user
    user.attributes = user_params
    if user.save
      render json: user, serializer: UserSerializer
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private
  def user_params
    params.require(:user).permit(:style)
  end
end
