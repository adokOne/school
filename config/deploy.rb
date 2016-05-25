# Change these
#server '193.84.22.53', port: 22 , user: 'adok', roles: [:web, :app, :db], primary: true
server '195.191.25.103', port: 22 , user: 'tildvfws', roles: [:web, :app, :db], primary: true
set :repo_url,        'ssh://git@github.com/adokOne/school.git'
set :application,     'school'
set :user,            'tildvfws'
set :rvm_type, :system                     # Defaults to: :auto
set :rvm_ruby_version, 'ruby 2.2.4p230'      # Defaults to: 'default'

#set :default_env, { path: "/home/tildvfws/rubyvenv/school/2.2/bin/activate" }

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :branch,        :develop
set :keep_releases, 1
set :tmp_dir, "#{deploy_to}/tmp"
## Defaults:
# set :scm,           :git
# set :branch,        :new_dep
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5


set :default_env, {
  'PATH' => '/home/tildvfws/rubyvenv/school/2.2/bin:/opt/alt/ruby22/bin:/usr/local/jdk/bin:/usr/local/jdk/bin:/usr/local/jdk/bin:/usr/local/jdk/bin:/home/tildvfws/perl5/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11R6/bin:/home/tildvfws/bin:/usr/local/bin:/usr/X11R6/bin:/home/tildvfws/bin:/usr/local/bin:/usr/X11R6/bin:/home/tildvfws/bin:/usr/local/bin:/usr/X11R6/bin:/home/tildvfws/bin:/home/tildvfws/rubyvenv/school/2.2/bin',
  'GEM_PATH' => '/home/tildvfws/rubyvenv/school/2.2:/opt/alt/ruby22/lib64/ruby/gems/2.2.0'
}


set :bundle_cmd, "source /home/tildvfws/rubyvenv/school/2.2/bin/activate && cd #{release_path} && /usr/bin/env bundle install --path /home/tildvfws/school/shared/bundle --without development test --deployment --quiet"

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

namespace :bundle do
  desc "Task description"
  task :install  do
    on roles(:app) do
      execute "source /home/tildvfws/rubyvenv/school/2.2/bin/activate && cd #{release_path} && /usr/bin/env bundle install --path /home/tildvfws/school/shared/bundle --without development test --deployment --quiet"
    end
  end
end

set :default_environment, {
  'PATH' => "$PATH:/usr/local/ruby/bin/"
}

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
after "deploy:updated", "bundle:install"
namespace :deploy do


  task :set_env do
    on roles(:app) do
      execute "source /home/tildvfws/rubyvenv/school/2.2/bin/activate"
    end
  end

  task :bundle_gems do
    on roles(:app) do
      execute "source /home/tildvfws/rubyvenv/school/2.2/bin/activate && cd #{release_path} && /usr/bin/env bundle install --path /home/tildvfws/school/shared/bundle --without development test --deployment --quiet"
    end
  end

  before :starting, :set_env


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

  before :finishing,     :bundle_gems
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



