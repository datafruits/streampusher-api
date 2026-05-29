class DjSessionsController < Devise::SessionsController

  def create
    if params[:call] == "publish"
      return authenticate_via_stream_key
    end

    resource = warden.authenticate(scope: resource_name)
    if resource.nil?
      render json: { success: false, error: "Invalid login or password" }, status: :unauthorized
      return
    end

    unless resource.dj? || resource.manager? || resource.admin?
      render json: { success: false, error: "User does not have DJ privileges" }, status: :unauthorized
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

  private

  def authenticate_via_stream_key
    user = User.find_by(stream_key: params[:name])
    if user.nil?
      render json: { success: false, error: "Invalid stream key" }, status: :unauthorized
      return
    end

    unless user.dj? || user.manager? || user.admin?
      render json: { success: false, error: "User does not have DJ privileges" }, status: :unauthorized
      return
    end

    # TODO do metadata stuff here???
    metadata = "LIVE -- #{user.username}"
    RedisMetadataPublisher.perform @current_radio.name, metadata
    LiquidsoapMetadataUpdate.perform(@current_radio, { title: metadata })
    CanonicalMetadataSync.perform(@current_radio.id, metadata )
    render json: { success: true, login: user.username, id: user.id }
  end
end
