class PlaylistsController < ApplicationController
  def show
    @playlist = Playlist.includes(playlist_tracks: [track: [:labels]]).find params[:id]
    authorize! :manage, @playlist, params[:format]
    respond_to do |format|
      format.html {
        render 'show'
      }
      format.json {
        render json: @playlist
      }
    end
  end

  def index
    authorize! :manage, Playlist, params[:format]
    @tracks = @current_radio.tracks
    @playlists = @current_radio.playlists.includes(tracks: [:labels])
    respond_to do |format|
      format.html {
        redirect_to playlist_path(@current_radio.default_playlist)
      }
      format.json {
        render json: @playlists
      }
    end
  end

  def create
    @playlist = @current_radio.playlists.new create_params
    authorize! :manage, @playlist, params[:format]
    if @playlist.save
      ActiveSupport::Notifications.instrument 'playlist.created', current_user: current_user.email, radio: @current_radio.name, playlist: @playlist.name
      render json: @playlist
    else
      render json: @playlist.errors
    end
  end

  def edit
    @playlist = @current_radio.playlists.find params[:id]
    authorize! :manage, @playlist, params[:format]
  end

  def update
    @playlist = @current_radio.playlists.includes(:playlist_tracks, :tracks).find params[:id]
    authorize! :manage, @playlist, params[:format]
    @playlist.attributes = update_params
    if @playlist.save
      ActiveSupport::Notifications.instrument 'playlist.updated', current_user: current_user.email, radio: @current_radio.name, playlist: @playlist.name, params: update_params
      render json: @playlist
    else
      render json: @playlist.errors
    end
  end

  def destroy
    @playlist = @current_radio.playlists.find params[:id]
    authorize! :destroy, @playlist, params[:format]
    if @playlist.destroy
      render json: @playlist
    else
      render json: @playlist.errors
    end
  end

  private
  def create_params
    params.require(:playlist).permit(:name, :radio_id)
  end

  def update_params
    params.require(:playlist).permit(:name, :interpolated_playlist_id,
                                     :interpolated_playlist_track_play_count,
                                     :interpolated_playlist_track_interval_count,
                                     :interpolated_playlist_enabled, :no_cue_out,
                                     :shuffle)
  end
end
