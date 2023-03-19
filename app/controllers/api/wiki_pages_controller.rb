class Api::WikiPagesController < ApplicationController
  load_and_authorize_resource except: [:show, :index, :create]
  before_action :current_radio_required

  def index
    @wiki_pages = WikiPage.all.order("updated_at DESC")
    render json: @wiki_pages
  end

  def show
    @wiki_page = WikiPage.friendly.find(params[:id])
    render json: @wiki_page, include: 'wiki_page_edits'
  end

  def create
    authorize! :create, WikiPage
    @wiki_page = WikiPage.new
    if @wiki_page.save_new_edit! wiki_page_params.except(:summary), current_user.id
      ActiveSupport::Notifications.instrument 'wiki_page.created', username: current_user.username, wiki_page: @wiki_page.title, slug: @wiki_page.slug
      render json: @wiki_page, root: "wiki_page"
    else
      render json: { errors: @wiki_page.errors }, status: 422
    end
  end

  def update
    @wiki_page = WikiPage.friendly.find(params[:id].downcase.gsub(" ", "-").gsub(/[^0-9a-z-]/i, ''))
    if @wiki_page.save_new_edit! wiki_page_params, current_user.id
      ActiveSupport::Notifications.instrument 'wiki_page.updated', username: current_user.username, wiki_page: @wiki_page.title, slug: @wiki_page.slug
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
