class RadiosController < ApplicationController
  load_and_authorize_resource except: :next
  def index
    @radio = @current_radio
    render json: @radio
  end

  def edit

  end

  def update
    @radio.attributes = update_params
    if @radio.save
      SaveRadioSettingsToRedisWorker.perform_later @radio.id
      redirect_to edit_radio_path(@radio)
    else
      render 'edit'
    end
  end

  def next
    @radio = Radio.find_by_name(params[:id])
    render json: NextTrack.perform(@radio)
  end

  def queue_current_show
    @radio = @current_scheduled_show
    current_show = @radio.current_scheduled_show
    if current_show.playlist_id != @radio.default_playlist_id
      current_show.queue_playlist!
      render head: :ok
    end
  end

  private
  def update_params
    params.require(:radio).permit(:default_playlist_id,
      :tunein_metadata_updates_enabled, :tunein_station_id, :tunein_partner_key,
      :tunein_partner_id, :show_share_url)
  end
end
