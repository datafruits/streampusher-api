class Api::ScheduledShowsController < ApplicationController
  def show
    scheduled_show = @current_radio.scheduled_shows.friendly.find(params[:id])
    if scheduled_show
      render json: scheduled_show, serializer: ScheduledShowSerializer
    else
      render json: { "error": "not found" } , status: 404
    end
  end
end
