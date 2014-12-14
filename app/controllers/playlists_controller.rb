class PlaylistsController < ApplicationController
  def index
    @tracks = current_radio.tracks
    @playlists = current_radio.playlists
  end

  def create

  end
end
