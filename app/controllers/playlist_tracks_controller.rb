class PlaylistTracksController < ApplicationController
  load_and_authorize_resource
  def create
    @playlist_track = PlaylistTrack.new playlist_track_params
    if @playlist_track.save
      #flash[:notice] = "added #{@playlist_track.track.display_name} to playlist #{@playlist_track.playlist.name}!"
      #render 'create'
    else
      #flash[:error] = "error adding #{@playlist_track.track.display_name} to #{@playlist_track.playlist.name} :("
      #render 'error'
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
    @playlist = @current_radio.playlists.find playlist_track_params[:playlist_id]
    @playlist_track = PlaylistTrack.find(params[:id])
    if @playlist_track.destroy
      flash[:notice] = 'removed track from playlist!'
      render 'destroy'
    else
      flash[:error] = 'error removing track from playlist :('
      render 'error'
    end
  end

  private
  def playlist_track_params
    params.require(:playlistTrack).permit(:podcast_published_date, :playlist_id, :track_id)
  end
end
