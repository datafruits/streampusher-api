class SkipTrackController < ApplicationController
  before_action :current_radio_required
  def create
    authorize! :update, :metadata
    if SkipTrack.perform @current_radio
      render 'create'
    else
      render 'error'
    end
  end
end
