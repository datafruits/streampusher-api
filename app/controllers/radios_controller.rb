class RadiosController < ApplicationController
  load_and_authorize_resource
  def index
    @radio = Radio.new
  end
  def create
    @radio.user_id = current_user.id
    if @radio.save
      redirect_to 'index'
    else
      render 'index'
    end
  end
end
