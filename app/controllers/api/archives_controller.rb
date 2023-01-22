class Api::ArchivesController < ApplicationController
  before_action :current_radio_required
  serialization_scope :serializer_scope

  def index
    playlist = @current_radio.default_playlist

    render json: playlist, serializer: ArchivesPlaylistSerializer, include: 'tracks', meta: { total_pages: playlist.tracks.page.total_pages.to_i, page: params[:page] }
  end

  private
  def serializer_scope
    if params[:tags].is_a? String
      tags = Array(params[:tags].split(","))
    else
      tags = Array(params[:tags])
    end
    {
      tracks: {
        page: params[:page],
        query: params[:query],
        tags: tags
      }
    }
  end
end
