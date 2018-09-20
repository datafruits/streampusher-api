class HostApplicationsController < ApplicationController
  load_and_authorize_resource except: [:create]
  before_action :current_radio_required, only: [:create]

  def index
    # authorize! :manage, HostApplication
    @host_applications = @current_radio.host_applications
  end

  def create
    @host_application = @current_radio.host_applications.new host_application_params
    if @host_application.save
      ActiveSupport::Notifications.insturment 'host_application.created', radio: @current_radio.name, username: @host_application.username
      render json: @host_application
    else
      render json: @host_application.errors
    end
  end

  private
  def host_application_params
    params.require(:host_application).permit(:username, :email, :time_zone, :link, :interval)
  end
end
