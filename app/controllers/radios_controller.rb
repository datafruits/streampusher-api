class RadiosController < ApplicationController
  load_and_authorize_resource
  def index
    @radio = Radio.new
  end
  def boot

  end
  def create
    @radio.user_id = current_user.id
    if @radio.save
      redirect_to radios_path
    else
      render 'index'
    end
  end
end
