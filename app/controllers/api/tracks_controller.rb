class Api::TracksController < ApplicationController
  before_action :current_radio

  def index
    @tracks = @current_radio.tracks.where("id in (?)", params[:id])

    render json: @tracks
  end

  def show
    @track = @current_radio.tracks.find params[:id]

    render json: @track
  end
end
