class Api::WikiPagesController < ApplicationController
  load_and_authorize_resource except: [:show, :index]
  before_action :current_radio_required

  def index
    @wiki_pages = WikiPage.all
    render json: @wiki_pages
  end

  def show
    @wiki_page = WikiPage.friendly_find(params[:id])
    render json: @wiki_page
  end
end