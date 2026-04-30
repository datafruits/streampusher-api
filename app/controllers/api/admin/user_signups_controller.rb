class Api::Admin::UserSignupsController < ApplicationController
  def index
    authorize! :admin, :dashboard

    # Build query with optional date filtering
    users_query = User.where("created_at >= ?", 1.year.ago)

    # if filter_params[:start]
    #   start_date = DateTime.parse(filter_params[:start])
    #   users_query = users_query.where("created_at >= ?", start_date)
    # end
    #
    # if filter_params[:end]
    #   end_date = DateTime.parse(filter_params[:end])
    #   users_query = users_query.where("created_at <= ?", end_date)
    # end
    #
    user_signups = users_query.group_by { |m| m.created_at.beginning_of_month }.map {|k,v| [k.strftime("%B %Y"), v.count] }.to_h

    render json: { user_signups: user_signups }
  end

  private

  def filter_params
    params.permit(:start, :end)
  end
end
