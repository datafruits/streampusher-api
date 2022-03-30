class Api::WikiPagesController < ApplicationController
  load_and_authorize_resource except: [:show]
  before_action :current_radio_required

  def show
    render json: @wiki_page
  end
end
