class TracksController < ApplicationController
  load_and_authorize_resource
  def create
    @track = current_radio.tracks.new create_params
    if @track.save
      render 'create'
    else
      render 'error'
    end
  end

  private
  def create_params
    params.require(:track).permit(:radio_id, :audio_file_name)
  end
end
