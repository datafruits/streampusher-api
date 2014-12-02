class PlaylistsController < ApplicationController
  def index
    @tracks = current_radio.tracks
    @playlists = current_radio.playlists
    @track = current_radio.tracks.new
  end

  def create

  end
end
