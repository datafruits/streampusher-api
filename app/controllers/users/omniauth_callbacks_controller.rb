class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def soundcloud
    @social_identity = SocialIdentity.create_with_omniauth request.env["omniauth.auth"], current_user.id
    redirect_to social_identities_path
  end

  def mixcloud
    @social_identity = SocialIdentity.create_with_omniauth request.env["omniauth.auth"], current_user.id
    redirect_to social_identities_path
  end
end
