# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

staging_host = ENV.fetch('STAGING_HOST', 'staging.datafruits.fm')

server staging_host,
       user: ENV.fetch('STAGING_DEPLOY_USER', 'deploy'),
       roles: %w[web app db],
       primary: true

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/var/www/#{fetch(:full_app_name)}"
set :server_name, ENV.fetch('STAGING_SERVER_NAME', staging_host)

# Nginx terminates TLS/HTTP2 and talks HTTP/1.1 to Falcon on localhost.
set :falcon_host, '127.0.0.1'
set :falcon_port, ENV.fetch('STAGING_FALCON_PORT', '3000')
set :ssl_certificate_name, ENV.fetch('STAGING_SSL_CERTIFICATE_NAME', fetch(:server_name))
set :falcon_service_name, "falcon_#{fetch(:full_app_name)}"

# Staging runs Falcon under systemd. Keep the production stage on its legacy
# Unicorn setup until it is migrated separately.
set :config_files, fetch(:config_files).reject { |file| file.start_with?('unicorn') || file == 'application.yml' } + %w[falcon.service]
set :executable_config_files, fetch(:executable_config_files).reject { |file| file.start_with?('unicorn') }
set :symlinks, fetch(:symlinks).reject { |link| link[:source].start_with?('unicorn') }

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#set :ssh_options, {
#  keys: %w(/Users/tony/.vagrant.d/insecure_private_key),
#  forward_agent: false,
#  auth_methods: %w(password),
#}
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# dont try and infer something as important as environment from
# stage name.
set :rails_env, :staging

# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
set :unicorn_worker_count, 5

# whether we're using ssl or not, used for building nginx
# config file
# TLS is the normal staging configuration. Set STAGING_ENABLE_SSL=false only
# when bootstrapping or recovering certificates over plain HTTP.
set :enable_ssl, ENV.fetch('STAGING_ENABLE_SSL', 'true') == 'true'
