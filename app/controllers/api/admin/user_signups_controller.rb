class Api::Admin::UserSignupsController < ApplicationController
  def index
    authorize! :admin, :dashboard

    # Get user signups grouped by month using PostgreSQL DATE_TRUNC
    user_signups_by_month = User.group("DATE_TRUNC('month', created_at)")
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
end