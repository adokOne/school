# Change these
server '193.84.22.53', port: 22 , user: 'adok', roles: [:web, :app, :db], primary: true

set :repo_url,        'ssh://git@github.com/adokOne/school.git'
set :application,     'school'
set :user,            'adok'
set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, 'ruby-head'      # Defaults to: 'default'

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :branch,        :develop
set :keep_releases, 1

## Defaults:
# set :scm,           :git
# set :branch,        :new_dep
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5



####################### PUMA ##########################
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock" #accept array for multi-bind
set :puma_conf,       "#{shared_path}/puma.rb"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_role, :app
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to true if using ActiveRecord
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
###################### PASSENGER ##########################


namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/tmp/sockets "
      execute "mkdir -p #{shared_path}/tmp/pids "
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  #before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
  after  :finishing, "whenever:update_crontab"
end
## Linked Files & Directories (Default None):

set :linked_files, %w{config/secrets.yml config/database.yml }
set :linked_dirs, %w{public/system tmp/cache log}
# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma



