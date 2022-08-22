class PlaylistTracksController < ApplicationController
  load_and_authorize_resource
  def create
    @playlist_track = PlaylistTrack.new playlist_track_params
    # @playlist_track.position_position = :last
    if @playlist_track.save
      render json: @playlist_track
    else
      render json: @playlist_track.errors
    end
  end

  def edit
    @playlist_track = PlaylistTrack.find params[:id]
  end

  def update
    @playlist_track.attributes = playlist_track_params
    if @playlist_track.save
      @playlist_track.insert_at(playlist_track_params[:position])
      render json: @playlist_track
    else
      render json: @playlist_track.errors
    end
  end

  def destroy
    @playlist_track = PlaylistTrack.find(params[:id])
    if @playlist_track.destroy
      head :no_content
    else
      render json: @playlist_track.errors
    end
  end

  private
  def playlist_track_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :podcast_published_date, :playlist, :track, :position
    ])
  end
end
