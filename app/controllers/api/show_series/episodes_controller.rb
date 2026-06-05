class Api::ShowSeries::EpisodesController < ApplicationController
  def index
    episodes = ::ShowSeries.friendly.find(params[:show_series_id]).episodes
    if params[:status] === "archive_published"
      episodes = episodes.archive_published.order("start_at DESC")
    elsif params[:status] === "archive_unpublished"
      episodes = episodes.archive_unpublished.order("start_at ASC")
    end
    episodes = episodes.page(params[:page])
    options = {}
    options[:meta] = { page: params[:page], total_pages: episodes.total_pages.to_i }
    render json: Fast::ScheduledShowSerializer.new(episodes, options).serializable_hash.to_json
  end

  def show
    episode = ::ShowSeries.friendly.find(params[:show_series_id]).episodes.friendly.find(params[:id])
    render json: episode, include: ['posts', 'labels', 'tracks', 'recording', 'djs']
  end
end
