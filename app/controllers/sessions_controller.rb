# the worst case of cargo culting i have ever commited :(

class SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => :failure)
    return sign_in_and_redirect(resource_name, resource)
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    render :json => {:success => true,
                     :redirect => stored_location_for(scope) || after_sign_in_path_for(resource),
                     :login => resource.username,
                     :id => resource.id,
                     :token => request.env['warden-jwt_auth.token']}
  end

  def destroy
    super
  end
end
