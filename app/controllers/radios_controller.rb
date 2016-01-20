class RadiosController < ApplicationController
  load_and_authorize_resource except: :next
  def index
    @radio = @current_radio
  end

  def create
    @radio.subscription_id = current_user.subscription.id
    if @radio.save
      redirect_to radios_path
    else
      render 'index'
    end
  end

  def edit

  end

  def update
    @radio.attributes = create_params
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
  def create_params
    params.require(:radio).permit(:name, :virtual_host, :default_playlist_id)
  end
end
