class Api::Djs::TracksController < ApplicationController
  def index
    djs = @current_radio.djs
      .includes(tracks: [ :radio, :uploaded_by, :labels ]).where(enabled: true)
    @dj = djs.find(params[:dj_id])
    tracks = @dj.tracks.page(params[:page])

    meta = { page: params[:page], total_pages: tracks.total_pages.to_i }
    render json: tracks, meta: meta
  end
end
