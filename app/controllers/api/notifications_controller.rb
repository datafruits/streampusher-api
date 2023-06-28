class Api::NotificationsController < ApplicationController
  def index
    notifications = current_user.notifications.order("created_at DESC")
    render json: notifications
  end
end
