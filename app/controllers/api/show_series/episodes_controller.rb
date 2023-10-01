class Api::ShowSeries::EpisodesController < ApplicationController
  def index
    episodes = ::ShowSeries.friendly.find(params[:show_series_id]).episodes #.page(params[:page])
    if params[:status] === "archive_published"
      episodes = episodes.where(status: "archive_published")
    elsif params[:status] === "archive_unpublished"
      episodes = episodes.where(status: "archive_unpublished")
    end
    episodes = episodes.page(params[:page])
    render json: episodes
  end

  def show
    episode = ::ShowSeries.friendly.find(params[:show_series_id]).episodes.friendly.find(params[:id])
    render json: episode, include: ['posts', 'labels', 'tracks', 'recording']
  end
end
