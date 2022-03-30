# config valid only for Capistrano 3.1
lock '3.16.0'

set :log_level, ENV.fetch('CAP_LOG_LEVEL', :info)

set :application, 'stream_pusher'
set :repo_url, 'git@github.com:streampusher/api.git'

# setup rbenv
set :rbenv_type, :system
set :rbenv_ruby, '2.6.5'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

set :slack_webhook, ENV['DEPLOY_NOTIFY_URL']

set :deploy_user, "deploy"

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v6.17.1'

# Default branch is :main
set :branch, ENV['DEPLOY_BRANCH'] || "main"
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :init_system, :systemd
set :bundler_path, '/usr/local/rbenv/shims/bundle' # for sidekiq systemd service

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml backup/.env}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :sidekiq_pid, "#{current_path}/tmp/pids/sidekiq.pid"
set :sidekiq_service_name, "sidekiq_worker"
set :sidekiq_default_hooks, false
set :sidekiq_service_unit_name, 'sidekiq-production'


# Default value for default_env is {}
set :default_env, {
  "EXECJS_RUNTIME": "Node"
}

# Default value for keep_releases is 5
set :keep_releases, 2
#
# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  application.yml
  database.example.yml
  log_rotation
  sidekiq_init.sh
  sidekiq.yml
  unicorn.rb
  unicorn_init.sh
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
  sidekiq_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/{{full_app_name}}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_{{full_app_name}}"
  },
  {
    source: "log_rotation",
   link: "/etc/logrotate.d/{{full_app_name}}"
  },
  #{
  #  source: "monit",
  #  link: "/etc/monit/conf.d/{{full_app_name}}.conf"
  #},
  {
    source: "sidekiq_init.sh",
    link: "/etc/init.d/sidekiq_{{full_app_name}}"
  }
])

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end


  before :deploy, "deploy:check_revision"
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'
  after 'deploy:setup_config', 'nginx:reload'
  # after 'deploy:setup_config', 'monit:restart'
  # after "deploy:setup_config", "backup:setup"

  # after 'deploy:starting', 'sidekiq:quiet'
  # after 'deploy:updated', 'sidekiq:monit:stop'
  # after 'deploy:reverted', 'sidekiq:monit:stop'
  # after 'deploy:published', 'sidekiq:monit:restart'
  # after 'deploy:updated', 'sidekiq:stop'
  # after 'deploy:reverted', 'sidekiq:stop'
  # after 'deploy:published', 'sidekiq:restart'
end
