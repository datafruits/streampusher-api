class ShowsController < ApplicationController
  before_action :current_radio_required

  def index
    @query = params[:query].to_s.strip
    @shows = public_shows.includes(:users, :labels, as_image_attachment: :blob).order(:title, :id)
    if @query.present?
      @shows = @shows.where('title ILIKE ?', "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%")
    end
    @shows = @shows.page(params[:page]).per(24)
  end

  def show
    @show = public_shows.includes(:users, :labels).friendly.find(params[:id])
    @episodes = @show.episodes.where(radio_id: @current_radio.id).archive_published.
      where('end_at < ?', Time.current).includes(:labels, :performers).
      order(start_at: :desc, id: :desc).page(params[:page]).per(20)
  end

  private

  def public_shows
    @current_radio.show_series.where.not(status: :disabled)
  end
end
