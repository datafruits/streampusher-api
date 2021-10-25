class HostApplicationsController < ApplicationController
  load_and_authorize_resource except: [:create]
  before_action :current_radio_required, only: [:create]

  def index
    # authorize! :manage, HostApplication
    @host_applications = @current_radio.host_applications.order("created_at DESC")
  end

  def create
    @host_application = @current_radio.host_applications.new host_application_params
    if @host_application.save
      ActiveSupport::Notifications.instrument 'host_application.created', radio: @current_radio.name, username: @host_application.username, link: @host_application.link
      render json: @host_application
    else
      render json: { errors: @host_application.errors }, status: 422
    end
  end

  private
  def host_application_params
    params.require(:host_application).permit(:username, :email, :time_zone,
                                             :link, :interval, :desired_time,
                                             :other_comment, :homepage_url)
  end
end
