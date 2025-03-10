class Api::MyShowsController < ApplicationController
  include ErrorSerializer

  def show
    show_series = ShowSeries.friendly.find params[:id]

    render json: show_series, include: ['episodes', 'labels']
  end

  def index
    authorize! :index, :my_shows

    show_series = ShowSeries.joins("inner join show_series_hosts on show_series_hosts.user_id = #{current_user.id} and show_series_hosts.show_series_id = show_series.id").order("created_at DESC")

    render json: show_series
  end

  def create
    authorize! :create, ShowSeries
    if my_show_params[:recurring_interval] === "not_recurring"
      guest_series = ShowSeries.find_by(title: "GuestFruits")
      episode = guest_series.episodes.new my_show_params.except(:recurring_interval, :recurring_cadence, :recurring_weekday, :start_date, :end_date, :start_time, :end_time)
      start_time = DateTime.parse my_show_params[:start_time]
      end_time = DateTime.parse my_show_params[:end_time]
      start_date = DateTime.parse my_show_params[:start_date]
      time_zone = current_user.time_zone
      episode.start_at = DateTime.new start_date.year,
                                      start_date.month,
                                      start_date.day,
                                      start_time.hour,
                                      0,
                                      0,
                                      current_user.time_zone
      episode.end_at = episode.start_at + ((end_time - start_time) * 24).to_i.hours
      episode.playlist = guest_series.radio.default_playlist
      episode.dj_id = users_params[:user_ids].first
      episode.radio_id = guest_series.radio_id
      # TODO add hosts
      # if users_params.has_key? :user_ids
      #   users_params[:user_ids].each do |user_id|
      #     show_series.show_series_hosts.build user_id: user_id
      #   end
      # end
      if labels_params.has_key? :label_ids
        labels_params[:label_ids].each do |label_id|
          episode.scheduled_show_labels.build label_id: label_id
        end
      end
      episode.status = 'archive_unpublished'
      if episode.save
        ActiveSupport::Notifications.instrument 'guest_show.created', current_user: current_user.email, show_series: episode.title
        render json: guest_series
      else
        ActiveSupport::Notifications.instrument 'guest_show.create.error', current_user: current_user.email, show_series: episode.title, errors: episode.errors, params: params
        render json: ErrorSerializer.serialize(episode.errors), status: 422
      end
    else
      show_series = ShowSeries.new my_show_params
      show_series.status = 'active'
      if users_params.has_key? :user_ids
        users_params[:user_ids].each do |user_id|
          show_series.show_series_hosts.build user_id: user_id
        end
      end
      if labels_params.has_key? :label_ids
        labels_params[:label_ids].each do |label_id|
          show_series.show_series_labels.build label_id: label_id
        end
      end
      show_series.time_zone = current_user.time_zone
      if show_series.save
        ActiveSupport::Notifications.instrument 'show_series.created', current_user: current_user.email, show_series: show_series.title
        render json: show_series
      else
        ActiveSupport::Notifications.instrument 'show_series.create.error', current_user: current_user.email, show_series: show_series.title, errors: show_series.errors, params: params
        render json: ErrorSerializer.serialize(show_series.errors), status: 422
      end
    end
  end

  def update
    show_series = ShowSeries.friendly.find params[:id]
    authorize! :update, show_series
    show_series.attributes = my_show_params
    if labels_params.has_key? :label_ids
      show_series.labels = Label.find(labels_params[:label_ids])
    end
    if users_params.has_key? :user_ids
      show_series.show_series_hosts = []
      users_params[:user_ids].each do |user_id|
        show_series.show_series_hosts.build user_id: user_id
      end
    end
    if show_series.save
      ActiveSupport::Notifications.instrument 'show_series.updated', current_user: current_user.email, show_series: show_series.title
      render json: show_series
    else
      ActiveSupport::Notifications.instrument 'show_series.update.error', current_user: current_user.email, show_series: show_series.title, errors: show_series.errors, params: params
      render json: ErrorSerializer.serialize(show_series.errors), status: 422
    end
  end

  private
  def my_show_params
    p = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title,
      :start_date,
      :end_date,
      :start_time,
      :end_time,
      :description, :image, :image_filename,
      :recurring_interval,
      :recurring_cadence,
      :recurring_weekday,
      :start, :end,
      :status
    ])
    if p[:image].present?
      image = Paperclip.io_adapters.for(p[:image])
      image.original_filename = p.delete(:image_filename)
      return p.except(:image_filename).merge({image: image})
    else
      return p.except(:image_filename).except(:image)
    end
  end

  def labels_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :labels
    ])
  end

  def users_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :users
    ])
  end
end
