class LandingController < ApplicationController
  before_action :save_referer
  def index
  end

  private
  def save_referer
    session['referer'] = request.env["HTTP_REFERER"]
  end
end
