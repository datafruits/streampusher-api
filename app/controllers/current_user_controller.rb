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
end
