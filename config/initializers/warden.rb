Warden::Manager.before_failure do |env, opts|
  ActiveSupport::Notifications.instrument 'user.login.failed', user: env["action_dispatch.request.request_parameters"]["user"], path: env["REQUEST_PATH"]
end
