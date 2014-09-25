class RadiosController < ApplicationController
  load_and_authorize_resource
  def index
  end
  def create
    if @radio.save
      redirect_to 'index'
    else
      render 'index'
    end
  end
end
