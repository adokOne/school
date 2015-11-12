set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}_test"
set :branch, :testing
set :linked_files, %w{config/secrets.yml config/database.yml}
