class EpisodesController < ApplicationController
  before_action :current_radio_required

  def show
    @show = @current_radio.show_series.where.not(status: :disabled).friendly.find(params[:show_id])
    @episode = @show.episodes.where(radio_id: @current_radio.id).
      includes(:performers, :labels, posts: :user).friendly.find(params[:id])
    @tracks = if @episode.archive_published? && @episode.end_at < Time.current
      @episode.tracks.where(radio_id: @current_radio.id).where.not(audio_file_name: [nil, '']).reorder(:id)
    else
      []
    end
  end
end
