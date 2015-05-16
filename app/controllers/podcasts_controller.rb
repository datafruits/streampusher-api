class PodcastsController < ApplicationController
  load_and_authorize_resource
  def index
    @playlists = current_radio.playlists
  end

  private
end
