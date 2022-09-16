class Api::WikiPagesController < ApplicationController
  load_and_authorize_resource except: [:show, :index, :create]
  before_action :current_radio_required

  def index
    @wiki_pages = WikiPage.all
    render json: @wiki_pages
  end

  def show
    @wiki_page = WikiPage.friendly.find(params[:id].gsub(" ", "-"))
    render json: @wiki_page, include: 'wiki_page_edits'
  end

  def create
    authorize! :create, WikiPage
    @wiki_page = WikiPage.new
    if @wiki_page.save_new_edit! wiki_page_params.except(:summary), current_user.id
      render json: @wiki_page, root: "wiki_page"
    else
      render json: { errors: @wiki_page.errors }, status: 422
    end
  end

  def update
    @wiki_page = WikiPage.friendly.find(params[:id].gsub(" ", "-"))
    if @wiki_page.save_new_edit! wiki_page_params, current_user.id
      render json: @wiki_page, root: "wiki_page"
    else
      render json: { errors: @wiki_page.errors }, status: 422
    end
  end

  private
  def wiki_page_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :body, :summary
    ])
  end
end
