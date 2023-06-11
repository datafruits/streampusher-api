class Api::ShowSeries::EpisodesController < ApplicationController
  def index
    episodes = ::ShowSeries.friendly.find(params[:show_series_id]).episodes.page(params[:page])
    render json: episodes
  end

  def show
    episode = ::ShowSeries.friendly.find(params[:show_series_id]).episodes.friendly.find(params[:id])
    render json: episode
  end
end
