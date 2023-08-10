class Api::NotificationsController < ApplicationController
  def index
    # TODO paginate
    notifications = current_user.notifications.order("created_at DESC")
    MarkNotificationsReadWorker.set(wait: 30.seconds).perform_later(current_user.id)
    render json: notifications
  end
end
