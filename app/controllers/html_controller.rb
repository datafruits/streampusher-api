##
# HtmlController - Base controller for all HTML-serving controllers.
#
# Unlike ApplicationController (which inherits from ActionController::API for JSON API endpoints),
# this controller inherits from ActionController::Base to support:
# - View rendering with ERB templates
# - CSRF protection
# - Flash messages
# - Hotwire (Turbo + Stimulus)
#
# API controllers continue to inherit from ApplicationController < ActionController::API,
# preserving the existing JSON API behavior.
class HtmlController < ActionController::Base
  protect_from_forgery with: :exception
end
