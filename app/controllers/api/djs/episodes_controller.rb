class Api::Djs::EpisodesController < ApplicationController
  def index
    djs = @current_radio.djs
      .includes(show_series_hosts: [ :show_series ]).where(enabled: true)
    @dj = djs.find(params[:dj_id])
    show_series = ShowSeries.joins("inner join show_series_hosts on show_series_hosts.user_id = #{@dj.id} and show_series_hosts.show_series_id = show_series.id")
      shows = @current_radio.scheduled_shows
        .includes([:tracks])
        .where(show_series_id: show_series.pluck(:id))
        .where(status: :archive_published)
        .order("start_at DESC")
    shows = shows.page(params[:page])

    # meta = { page: params[:page], total_pages: shows.total_pages.to_i }
    # render json: shows, meta: meta
    options = {}
    options[:meta] = { page: params[:page], total_pages: shows.total_pages.to_i }
    options[:include] = ['tracks']
    render json: Fast::ScheduledShowSerializer.new(shows, options).serializable_hash.to_json
  end
end
