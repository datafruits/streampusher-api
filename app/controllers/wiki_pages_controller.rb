class WikiPagesController < ApplicationController
  before_action :set_wiki_page, only: [:show, :edit, :update, :history]

  def index
    @wiki_pages = WikiPage.order(updated_at: :desc)
  end

  def show; end

  def new
    authorize! :create, WikiPage
    @wiki_page = WikiPage.new
  end

  def create
    authorize! :create, WikiPage
    @wiki_page = WikiPage.new
    @wiki_page.save_new_edit!(wiki_page_params.except(:summary), current_user.id)
    instrument_change("wiki_page.created")
    redirect_after_save
  rescue ActiveRecord::RecordInvalid => error
    respond_to_invalid_save(error.record)
  end

  def edit
    authorize! :update, @wiki_page
  end

  def update
    authorize! :update, @wiki_page
    @wiki_page.save_new_edit!(wiki_page_params, current_user.id)
    instrument_change("wiki_page.updated")
    redirect_after_save
  rescue ActiveRecord::RecordInvalid => error
    respond_to_invalid_save(error.record)
  end

  def history
    @wiki_page_edits = @wiki_page.wiki_page_edits.includes(:user).order(created_at: :desc)
  end

  def preview
    authorize! preview_wiki_page.persisted? ? :update : :create, preview_wiki_page
    html = render_to_string(
      partial: "wiki_pages/preview",
      locals: { title: wiki_page_params[:title], body: wiki_page_params[:body] }
    )

    datastar_request? ? datastar.patch_elements(html) : render(html: html.html_safe)
  end

  private

  def set_wiki_page
    @wiki_page = WikiPage.friendly.find(params[:id])
  end

  def preview_wiki_page
    @preview_wiki_page ||= params[:id].present? ? WikiPage.friendly.find(params[:id]) : WikiPage.new
  end

  def wiki_page_params
    params.require(:wiki).permit(:title, :body, :summary)
  end

  def redirect_after_save
    datastar_request? ? datastar.redirect(wiki_page_path(@wiki_page)) : redirect_to(wiki_page_path(@wiki_page))
  end

  def respond_to_invalid_save(record)
    message = record.errors.full_messages.to_sentence.presence || "Couldn't save wiki article."

    if datastar_request?
      datastar.patch_signals(wiki: { error: message })
    else
      @wiki_page.errors.add(:base, message) unless @wiki_page.errors.any?
      render @wiki_page.persisted? ? :edit : :new, status: :unprocessable_entity
    end
  end

  def instrument_change(event_name)
    ActiveSupport::Notifications.instrument(
      event_name,
      username: current_user.username,
      wiki_page: @wiki_page.title,
      slug: @wiki_page.slug
    )
  end
end
