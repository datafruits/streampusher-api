class PlaylistTracksController < ApplicationController
  load_and_authorize_resource
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

  private
  def playlist_track_params
    params.require(:playlist_track).permit(:podcast_published_date)
  end
end
