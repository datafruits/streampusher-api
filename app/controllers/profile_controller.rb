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
      flash[:notice] = "Updated profile"
      redirect_to profile_index_path
    else
      flash[:notice] = "Couldn't update profile"
      render :index
    end
  end

  private
  def update_params
    params.require(:user).permit(:username, :image, :bio)
  end
end
