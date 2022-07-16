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

  def create
    @wiki_page = WikiPage.create wiki_page_params
  end

  private
  def wiki_page_params
    params.require(:wiki_page).permit(:title, :body)
  end
end
