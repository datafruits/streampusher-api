class TimetableController < ApplicationController
  def index
    start_at = Time.current.beginning_of_day
    end_at = start_at.next_month.end_of_month
    @scheduled_shows = @current_radio.scheduled_shows.
      where.not(show_series_id: nil).
      joins(:show_series).where(show_series: { status: :active }).
      where("start_at >= ? AND end_at <= ?", start_at, end_at).
      order("start_at ASC").
      includes(:performers, :scheduled_show_performers, :show_series)
  end
end
