set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}_staging"
set :branch, :master
set :linked_files, %w{config/secrets.yml config/database.yml config/mongoid.yml}
