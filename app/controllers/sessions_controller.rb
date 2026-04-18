# the worst case of cargo culting i have ever commited :(

class SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate(scope: resource_name)
    if resource
      sign_in_and_redirect(resource_name, resource)
    else
      render json: { success: false, error: "invalid login or password" }, status: :unauthorized
    end
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    render :json => {:success => true,
                     :redirect => stored_location_for(scope) || after_sign_in_path_for(resource),
                     :login => resource.username,
                     :id => resource.id,
                     :token => request.env['warden-jwt_auth.token'],
                     :dj_authorized => dj_authorized?(resource)}
  end

  def destroy
    super
  end

  private

  def dj_authorized?(resource)
    return false unless @current_radio
    resource.radios.include?(@current_radio) && (resource.dj? || resource.manager? || resource.admin?)
  end
end
