class Api::Admin::UserSignupsController < ApplicationController
  def index
    authorize! :admin, :dashboard

    # Build query with optional date filtering
    users_query = User
    
    if filter_params[:start]
      start_date = DateTime.parse(filter_params[:start])
      users_query = users_query.where("created_at >= ?", start_date)
    end
    
    if filter_params[:end]
      end_date = DateTime.parse(filter_params[:end])
      users_query = users_query.where("created_at <= ?", end_date)
    end

    # Get user signups grouped by month using PostgreSQL DATE_TRUNC
    user_signups_by_month = users_query.group("DATE_TRUNC('month', created_at)")
                                      .order("DATE_TRUNC('month', created_at)")
                                      .count

    # Transform the data to include month name and ensure consistent format
    formatted_data = user_signups_by_month.map do |month_date, count|
      {
        month: month_date.strftime("%Y-%m"),
        month_name: month_date.strftime("%B %Y"),
        count: count
      }
    end

    render json: { user_signups: formatted_data }
  end

  private

  def filter_params
    params.permit(:start, :end)
  end
end