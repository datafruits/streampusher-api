class DjsController < ApplicationController
  def index
    @djs = current_radio.djs
    @dj = @djs.new
  end

  def new
  end

  def create
    @dj = User.new dj_params
    @dj.user_radios.build(radio: current_radio)
    @dj.password = Devise.friendly_token.first(8)
    if @dj.save
      redirect_to djs_path
    else
      @djs = current_radio.djs
      render 'index'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def dj_params
    params.require(:user).permit(:email, :username)
  end
end
