class PerformanceTestsController < ActionController::Base
  before_action do
    if current_user && current_user.admin?
      Rack::MiniProfiler.authorize_request
    end
  end

  def index
  end
end
