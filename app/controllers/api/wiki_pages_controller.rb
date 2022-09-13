class Api::WikiPagesController < ApplicationController
  load_and_authorize_resource except: [:show, :index]
  before_action :current_radio_required

  def index
    @wiki_pages = WikiPage.all
    render json: @wiki_pages
  end

  def show
    @wiki_page = WikiPage.friendly.find(params[:id].gsub(" ", "-"))
    render json: @wiki_page
  end

  def create
    @wiki_page = WikiPage.new wiki_page_params
    if @wiki_page.save
      render json: @wiki_page, root: "wiki_page"
    else
      render json: { errors: @wiki_page.errors }, status: 422
    end
  end

  def update
    @wiki_page = WikiPage.friendly.find(params[:id].gsub(" ", "-"))
    # create new edit here
    if @wiki_page.save_new_edit! wiki_page_params[:title], wiki_page_params[:body], current_user.id
      render json: @wiki_page, root: "wiki_page"
    else
      render json: { errors: @wiki_page.errors }, status: 422
    end
  end

  private
  def wiki_page_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :body
    ])
  end
end
