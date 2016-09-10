class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  User.omniauth_providers.each do |provider|
    define_method "#{provider}" do
      @social_identity = SocialIdentity.create_with_omniauth request.env["omniauth.auth"], current_user.id
      redirect_to social_identities_path
    end
  end
end
