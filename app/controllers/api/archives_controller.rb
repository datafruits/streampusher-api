class Api::ArchivesController < ApplicationController
  before_action :current_radio_required
  serialization_scope :serializer_scope

  def index
    shows = @current_radio.scheduled_shows.
      where(status: :archive_published).
      order("start_at DESC").
      page(params[:page])

    if params[:query]
      shows = shows.where("title ILIKE (?)", "%#{params[:query]}%")
    end

    if params[:tags].is_a? String
      tags = Array(params[:tags].split(","))
    else
      tags = Array(params[:tags])
    end
    if tags.present?
      labels = tags.map{|t| Label.where("name ilike (?)", t).first }
      show_ids = labels.map{|l| l.scheduled_show_ids}.inject(:&)

      shows = shows.where("id in (?)", show_ids)
    end

    options = {}
    options[:meta] = { total_pages: shows.page.total_pages.to_i, page: params[:page].to_i }
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
