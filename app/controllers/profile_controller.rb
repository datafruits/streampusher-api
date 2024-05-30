class ProfileController < ApplicationController
  def index
    authorize! :index, :profile
    @dj = current_user
  end

  def create
    authorize! :create, :profile
    @dj = current_user
    @dj.attributes = update_params
    if @dj.save
      redirect_to profile_index_path
    else
      render :index
    end
  end

  private
  def update_params
    params.require(:user).permit(:username, :image, :bio, :pronouns)
  end
end
