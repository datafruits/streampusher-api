class DjSessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate(scope: resource_name)
    if resource.nil?
      render json: { success: false, error: "Invalid login or password" }, status: :unauthorized
      return
    end

    unless resource.dj? || resource.manager? || resource.admin?
      render json: { success: false, error: "User is not a DJ" }, status: :unauthorized
      return
    end

    sign_in_and_redirect(resource_name, resource)
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    render json: { success: true,
                   login: resource.username,
                   id: resource.id,
                   token: request.env['warden-jwt_auth.token'] }
  end
end
