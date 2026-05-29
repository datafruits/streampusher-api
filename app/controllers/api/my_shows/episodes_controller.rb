class Api::MyShows::EpisodesController < ApplicationController
  def update
    @scheduled_show = @current_radio.scheduled_shows.friendly.find(params[:id])
    authorize! :update, @scheduled_show

    @scheduled_show.attributes = create_params

    if labels_params.has_key? :label_ids
      @scheduled_show.labels = Label.find(labels_params[:label_ids])
    end

    if @scheduled_show.save
      ActiveSupport::Notifications.instrument 'scheduled_show.updated', current_user: current_user.email, radio: @current_radio.name, show: @scheduled_show.title, params: create_params
      render json: @scheduled_show
    else
      ActiveSupport::Notifications.instrument 'scheduled_show.update.error', current_user: current_user.email, radio: @current_radio.name, show: @scheduled_show.title, params: create_params, errors: @scheduled_show.errors
      render json: ErrorSerializer.serialize(@scheduled_show.errors), status: :unprocessable_entity
    end
  end

  def destroy
    @scheduled_show = @current_radio.scheduled_shows.find(params[:id])
    authorize! :destroy, @scheduled_show
    if @scheduled_show.destroy
      render json: @scheduled_show
    end
  end

  private
  def labels_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :labels
    ])
  end

  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :radio_id, :start_at,
      :end_at, :description, :image,
      :recurring_interval, :playlist, :time_zone,
      :start, :end, :is_guest, :guest, :is_live,
      :prerecord_track_id, :use_prerecorded_file_for_archive,
      :recording, :status, :youtube_link, :mixcloud_link, :soundcloud_link
    ])
  end
end
