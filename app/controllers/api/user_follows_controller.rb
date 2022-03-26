class Api::UserFollowsController < ApplicationController
  before_action :current_radio_required

  def create
    @user_follow = current_user.user_follows.create user_follow_params

    render json: @user_follow
  end

  def destroy
    @user_follow = current_user.user_follows.find(params[:id])

    @user_follow.destroy!
    head :ok
  end

  private
  def user_follow_params
    params.require(:user_follow).permit(:followee_id)
  end
end
