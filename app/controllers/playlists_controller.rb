class PlaylistsController < ApplicationController
  def index
    @tracks = current_radio.tracks
    @playlists = current_radio.playlists
    @playlist = current_radio.playlists.new
  end

  def create
    @playlist = current_radio.playlists.new create_params
    if @playlist.save
      render 'create'
    else
      render 'error'
    end
  end

  private
  def create_params
    params.require(:playlist).permit(:name)
  end
end
