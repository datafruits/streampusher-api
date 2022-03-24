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
    update_params = user_params
    update_params[:image] = update_params[:avatar]
    update_params[:image_filename] = update_params[:avatar_filename]
    update_params.delete(:avatar)
    update_params.delete(:avatar_filename)
    if update_params[:image].present?
      avatar = Paperclip.io_adapters.for(update_params[:image])
      avatar.original_filename = update_params.delete(:image_filename)
      user.attributes = update_params.except(:image_filename).merge({image: avatar})
    else
      user.attributes = update_params.except(:image_filename).except(:image)
    end
    if user.save
      render json: user, serializer: UserSerializer
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private
  def user_params
    params.require(:user).permit(:style, :avatar, :avatar_filename, :pronouns)
  end
end
