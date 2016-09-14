class PlaylistsController < ApplicationController
  load_and_authorize_resource
  def show
    @playlist = Playlist.includes(:tracks).find params[:id]
    authorize! :manage, @playlist, params[:format]
    respond_to do |format|
      format.html {
        @tracks = @current_radio.tracks
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
    @playlists = @current_radio.playlists.includes(:tracks)
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
      flash[:notice] = "created playlist"
      render json: @playlist
      #render 'create'
    else
      flash[:error] = "couldn't create playlist"
      render json: @playlist.errors
      #render 'error'
    end
  end

  def edit
    @playlist = @current_radio.playlists.find params[:id]
    authorize! :manage, @playlist, params[:format]
  end

  def update
    @playlist = @current_radio.playlists.includes(:tracks).find params[:id]
    authorize! :manage, @playlist, params[:format]
    @playlist.attributes = update_params
    if @playlist.save
      flash[:notice] = "updated playlist"
      #render "update"
      render json: @playlist
    else
      flash[:error] = 'error updating playlist :('
      #render 'edit'
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
                                     :interpolated_playlist_enabled)
  end
end
