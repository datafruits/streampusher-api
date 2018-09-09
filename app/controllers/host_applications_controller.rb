class HostApplicationsController < ApplicationController
  def index
    authorize! :manage, HostApplication
    @host_applications = @current_radio.host_applications
  end

  def create
    @host_application = @current_radio.host_application.new host_application_params
    authorize! :manage, @host_application
    if @host_application.save
      ActiveSupport::Notifications.insturment 'host_application.created', radio: @current_radio.name, username: @host_application.username
      render json: @host_application
    else
      render json: @host_application.errors
    end
  end

  private
  def host_application_params
    params.require(:host_application).permit(:username, :email, :time_zone)
  end
end
