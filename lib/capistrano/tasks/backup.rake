namespace :backup do
  desc 'sets up backups (install gems)'
  task :setup do
    on primary :web do
      backup_dir = "#{current_path}/#{fetch(:backup_path, 'backup')}"
      within backup_dir do
        with fetch(:bundle_env_variables, {}) do
          execute :bundle
        end
      end
    end
  end

  desc 'triggers the backup job'
  task :trigger do
    on primary :web do
      backup_dir = "#{current_path}/#{fetch(:backup_path, 'backup')}"
      within backup_dir do
        with fetch(:bundle_env_variables, {}).merge(rails_env: fetch(:rails_env)) do
          execute :bundle, "exec backup perform --trigger #{fetch(:backup_job, 'rails_database')} --config-file ./config.rb", raise_on_non_zero_exit: false
        end
      end
     end
  end
end
