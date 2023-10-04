class Api::ArchivesController < ApplicationController
  before_action :current_radio_required
  serialization_scope :serializer_scope

  def index
    shows = @current_radio.scheduled_shows.
      where(status: :archive_published).
      order("start_at DESC").
      page(params[:page])

    options = {}
    options[:meta] = { total_pages: shows.page.total_pages.to_i, page: params[:page] }
    options[:include] = ['tracks']
    render json: Fast::ScheduledShowSerializer.new(shows, options).serializable_hash.to_json
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
