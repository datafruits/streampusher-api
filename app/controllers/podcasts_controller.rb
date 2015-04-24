class PodcastsController < ApplicationController
  load_and_authorize_resource
  def index
    @tracks = current_radio.tracks
    @podcasts = current_radio.podcasts
    @podcast = current_radio.podcasts.new
  end
end
