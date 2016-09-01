class EmbedsController < ApplicationController
  before_action :set_frame_headers, only: [:player]

  def index
    authorize! :read, "embed"
  end

  def player
    @radio = @current_radio
    render :layout => false
  end

  private
  def set_frame_headers
    response.headers.delete "X-Frame-Options"
  end
end
