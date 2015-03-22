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

  def add_track
    @playlist = current_radio.playlists.find(params[:id])
    @track = current_radio.tracks.find params[:track][:id]
    if @playlist.add_track @track
      SavePlaylistToRedisWorker.perform_later @playlist.id
      flash[:notice] = 'added track to playlist!'
      render 'add_track_success'
    else
      flash[:error] = 'error adding track to playlist :('
      render ' add_track_error'
    end
  end

  def remove_track
    @playlist = current_radio.playlists.find(params[:id])
    @playlist_track = @playlist.playlist_tracks.find params[:playlist_track][:id]
    if @playlist.remove_track @playlist_track
      SavePlaylistToRedisWorker.perform_later @playlist.id
      flash[:notice] = 'removed track from playlist!'
      render 'remove_track_success'
    else
      flash[:error] = 'error removing track from playlist :('
      render 'remove_track_error'
    end
  end

  def update_order
    @playlist_track = PlaylistTrack.find(playlist_track_params[:playlist_track_id])
    @playlist_track.position = playlist_track_params[:position]
    @playlist_track.save

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end

  private
  def playlist_track_params
    params.require(:playlist_track).permit(:playlist_track_id, :position)
  end

  def create_params
    params.require(:playlist).permit(:name)
  end
end
