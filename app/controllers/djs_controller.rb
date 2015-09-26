class DjsController < ApplicationController
  def index
    @djs = @current_radio.djs.page(params[:page])
    @dj = @djs.new
  end

  def new
  end

  def create
    @dj = User.new dj_params
    @dj.user_radios.build(radio: @current_radio)
    password = Devise.friendly_token.first(8)
    @dj.password = password
    @dj.role = 'dj'
    if @dj.save
      DjAccountMailer.welcome_email(@dj, password, @current_radio).deliver_later
      flash[:notice] = "Created DJ account for #{@dj.email}"
      redirect_to djs_path
    else
      flash[:error] = "Couldn't create dj account"
      @djs = @current_radio.djs.page(params[:page])
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
