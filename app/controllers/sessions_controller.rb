# the worst case of cargo culting i have ever commited :(

class SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => :failure)
    if datastar_request?
      sign_in(resource_name, resource) unless warden.user(resource_name) == resource
      # Devise resets the CSRF token on login. Generate its replacement before
      # streaming so Rails can persist it in the session cookie.
      csrf_meta_tag = helpers.tag.meta(name: "csrf-token", content: form_authenticity_token)
      datastar.stream do |sse|
        sse.patch_elements(csrf_meta_tag, selector: 'meta[name="csrf-token"]', mode: "replace")
        sse.patch_elements(render_to_string(partial: "shared/nav_auth"))
        sse.patch_signals(loginModalOpen: false)
      end
    else
      return sign_in_and_redirect(resource_name, resource)
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
                     :token => request.env['warden-jwt_auth.token']}
  end

  def destroy
    super
  end
end
