class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protected
  def current_radio
    if !request.subdomain.blank?
      Radio.find_by_name request.subdomain
    else
      current_user.subscription.radios.first
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, current_radio)
  end
end
