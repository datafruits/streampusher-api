class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protected
  def current_radio
    if request.subdomain
      Radio.find_by_name request.subdomain
    else
      user.subscription.radio
    end
  end
end
