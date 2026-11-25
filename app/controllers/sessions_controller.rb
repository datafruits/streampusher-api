# the worst case of cargo culting i have ever commited :(

class SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => :failure)
    if datastar_request?
      sign_in(resource_name, resource) unless warden.user(resource_name) == resource
      session.delete(:chat_nickname)
      render_auth_navigation(loginModalOpen: false)
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

  private

  def respond_to_on_destroy(non_navigational_status: :no_content)
    return super unless datastar_request?

    session.delete(:chat_nickname)
    render_auth_navigation(loginModalOpen: false, userMenuOpen: false, settingsModalOpen: false)
  end

  def render_auth_navigation(**signals)
    # Authentication changes can reset the CSRF token. Generate its replacement
    # before streaming so Rails can persist it in the session cookie.
    csrf_meta_tag = helpers.tag.meta(name: "csrf-token", content: form_authenticity_token)
    nav_auth = render_to_string(partial: "shared/nav_auth")
    signals[:chat] = {
      joined: user_signed_in? || session[:chat_nickname].present?,
      nickname: "",
      body: "",
      error: nil
    }
    datastar.stream do |sse|
      sse.patch_elements(csrf_meta_tag, selector: 'meta[name="csrf-token"]', mode: "replace")
      sse.patch_elements(nav_auth)
      sse.patch_signals(signals)
    end
  end
end
