class PlaylistTracksController < ApplicationController
  load_and_authorize_resource
  def create
    @playlist = @current_radio.playlists.find(params[:playlist_id])
    @track = @current_radio.tracks.find params[:track][:id]
    if @playlist.add_track @track
      SavePlaylistToRedisWorker.perform_later @playlist.id
      flash[:notice] = "added #{@track.display_name} to playlist #{@playlist.name}!"
      render 'create'
    else
      flash[:error] = "error adding #{@track.display_name} to #{@playlist.name} :("
      render 'error'
    end
  end

  def edit
    @playlist_track = PlaylistTrack.find params[:id]
  end

  def update
    @playlist_track.attributes = playlist_track_params
    if @playlist_track.save
      flash[:notice] = "Playlist track updated."
      render 'update'
    else
      flash[:error] = "Error updating playlist track."
      render 'edit'
    end
  end

  def destroy
    @playlist = @current_radio.playlists.find(params[:playlist_id])
    @playlist_track = @playlist.playlist_tracks.find params[:id]
    if @playlist.remove_track @playlist_track
      SavePlaylistToRedisWorker.perform_later @playlist.id
      flash[:notice] = 'removed track from playlist!'
      render 'destroy'
    else
      flash[:error] = 'error removing track from playlist :('
      render 'error'
    end
  end

  private
  def playlist_track_params
    params.require(:playlist_track).permit(:podcast_published_date, :playlist_id)
  end
end
