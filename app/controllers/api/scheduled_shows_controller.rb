class Api::ScheduledShowsController < ApplicationController
  def show
    scheduled_show = @current_radio.scheduled_shows.friendly.find(params[:id])
    if scheduled_show
      render json: scheduled_show, serializer: ScheduledShowSerializer, include: params[:include].map{ |m| m.gsub(/-/, "_")}.join(',')
    else
      render json: { "error": "not found" } , status: 404
    end
  end

  def index
    if params[:term]
      @scheduled_shows = @current_radio.scheduled_shows.where("title ilike ?", "%#{params[:term]}%").order("start_at DESC").includes(:performers, :scheduled_show_performers)
    else
      if params[:start]
        start_at = DateTime.parse(params[:start]).in_time_zone(Time.zone.name)
      else
        start_at = 1.month.ago
      end
      @scheduled_shows = @current_radio.scheduled_shows.where("start_at >= ? AND end_at <= ?", start_at, params[:end]).order("start_at ASC").includes(:performers, :scheduled_show_performers)
      @scheduled_shows = @scheduled_shows.joins(:show_series).where(show_series: { status: :active })
    end

    render json: Fast::ScheduledShowSerializer.new(@scheduled_shows).serializable_hash.to_json
  end
end
