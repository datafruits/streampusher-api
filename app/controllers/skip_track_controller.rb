class SkipTrackController < ApplicationController
  before_action :current_radio_required
  def create
    authorize! :update, :metadata
    if SkipTrack.perform @current_radio.name
      flash[:notice] = "Updated!"
      render 'create'
    else
      flash[:error] = "Sorry, there was an error..."
      render 'error'
    end
  end
end
