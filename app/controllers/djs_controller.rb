class DjsController < ApplicationController
  def index
    @djs = current_radio.djs
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
