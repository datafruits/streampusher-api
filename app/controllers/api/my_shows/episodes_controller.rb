class Api::MyShows::EpisodesController < ApplicationController
  def update
    @scheduled_show = @current_radio.scheduled_shows.friendly.find(params[:id])
    authorize! :update, @scheduled_show
    if create_params[:image].present? && !create_params[:image].is_a?(Hash)
      image = Paperclip.io_adapters.for(create_params[:image])
      image.original_filename = create_params.delete(:image_filename)
      @scheduled_show.attributes = create_params.except(:image_filename).merge({image: image})
    else
      @scheduled_show.attributes = create_params.except(:image_filename).except(:image)
    end

    if @scheduled_show.save
      ActiveSupport::Notifications.instrument 'scheduled_show.updated', current_user: current_user.email, radio: @current_radio.name, show: @scheduled_show.title, params: create_params
      render json: @scheduled_show
    else
      render json: @scheduled_show.errors, status: :unprocessable_entity
    end
  end

  private
  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :radio_id, :start_at,
      :end_at, :description, :image, :image_filename,
      :recurring_interval, :playlist, :time_zone,
      :start, :end, :is_guest, :guest, :is_live,
      :prerecord_track_id, :use_prerecorded_file_for_archive,
      :recording, :status, :youtube_link
    ])
  end
end
