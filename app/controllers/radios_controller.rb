class RadiosController < ApplicationController
  load_and_authorize_resource except: :next
  def index
    @radio = @current_radio
  end

  def edit

  end

  def update
    @radio.attributes = update_params
    if @radio.save
      SaveRadioSettingsToRedisWorker.perform_later @radio.id
      flash[:notice] = "radio settings updated."
      redirect_to edit_radio_path(@radio)
    else
      flash[:error] = "error updating radio settings."
      render 'edit'
    end
  end

  def next
    @radio = Radio.find_by_name(params[:id])
    render json: NextTrack.perform(@radio)
  end

  private
  def update_params
    params.require(:radio).permit(:default_playlist_id,
      :tunein_metadata_updates_enabled, :tunein_station_id, :tunein_partner_key,
      :tunein_partner_id, :show_share_url)
  end
end
