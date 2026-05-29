class Api::Djs::EpisodesController < ApplicationController
  def index
    djs = @current_radio.djs
      .includes(show_series_hosts: [ :show_series ]).where(enabled: true)
    @dj = djs.find(params[:dj_id])

    hosted_series_ids = ShowSeries
      .joins(:show_series_hosts)
      .where(show_series_hosts: { user_id: @dj.id })
      .pluck(:id)

    # need to also check GuestFruits
    guest_fruits_series_id = ShowSeries
      .where(title: "GuestFruits")
      .pick(:id)

    guest_show_ids =
      if guest_fruits_series_id
        ScheduledShow
          .joins(:show_series)
          .where(
            dj_id: @dj.id ,
            show_series_id: guest_fruits_series_id
          )
            .pluck(:id)
      else
        []
      end

      shows = @current_radio.scheduled_shows
        .includes([:tracks])
        .where(
          "show_series_id IN (?) OR scheduled_shows.id IN (?)",
          hosted_series_ids,
          guest_show_ids
        )
        .where(status: :archive_published)
        .order("start_at DESC")
    shows = shows.page(params[:page])

    options = {}
    options[:meta] = { page: params[:page], total_pages: shows.total_pages.to_i }
    options[:include] = ['tracks']
    render json: Fast::ScheduledShowSerializer.new(shows, options).serializable_hash.to_json
  end
end
