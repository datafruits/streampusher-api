class CurrentUserController < ApplicationController
  def index
    user = current_user

    respond_to do |format|
      format.json {
        render json: user, serializer: UserSerializer
      }
    end
  end
end
