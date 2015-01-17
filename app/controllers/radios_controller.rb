class RadiosController < ApplicationController
  load_and_authorize_resource
  def index
    @radio = current_radio
  end

  def create
    @radio.subscription_id = current_user.subscription.id
    if @radio.save
      redirect_to radios_path
    else
      render 'index'
    end
  end

  private
  def create_params
    params.require(:radio).permit(:name, :virtual_host)
  end
end
