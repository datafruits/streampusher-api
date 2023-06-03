class Api::MyShowsController < ApplicationController
  def index
    authorize! :index, :my_shows

    show_series = ShowSeries.joins("inner join show_series_hosts on show_series_hosts.user_id = #{current_user.id}")

    render json: show_series
  end

  def create
    authorize! :create, ShowSeries
    if my_show_params[:recurring_interval] === "not_recurring"
      guest_series = ShowSeries.find_by(title: "GuestFruits")
      episode = guest_series.episodes.create my_show_params.except(:recurring_interval)
      if episode.save
        render json: guest_series
      else
        render json: { errors: guest_series.errors }, status: 422
      end
    else
      if my_show_params[:image].present?
        image = Paperclip.io_adapters.for(my_show_params[:image])
        image.original_filename = my_show_params.delete(:image_filename)
        show_series = ShowSeries.new my_show_params.except(:image_filename).merge({image: image})
      else
        show_series = ShowSeries.new my_show_params.except(:image_filename).except(:image)
      end
      show_series.show_series_hosts.build user: current_user
      if show_series.save
        render json: show_series
      else
        render json: { errors: show_series.errors }, status: 422
      end
    end
  end

  def update
    authorize! :create, ShowSeries
  end

  private
  def my_show_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title,
      :start_date,
      :end_date,
      :start_time,
      :end_time,
      :description, :image, :image_filename,
      :recurring_interval,
      :start, :end
    ])
  end
end
