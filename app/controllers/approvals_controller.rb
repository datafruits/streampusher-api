class ApprovalsController < ApplicationController
  def create
    host_application = HostApplication.find(params[:host_application_id])
    authorize! :manage, host_application
    host_application.approve!
    redirect_to host_applications_path
  end
end
