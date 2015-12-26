set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :branch, :uex
set :puma_conf,       "#{shared_path}/puma.rb"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock" #accept array for multi-bind

server '159.203.76.46', port: 22 , user: 'deploy', roles: [:web, :app, :db], primary: true

set :user,            'deploy'
set :rvm_ruby_version, 'ruby-2.2-head'      # Defaults to: 'default'

# # Simple Role Syntax
# # ==================
# # Supports bulk-adding hosts to roles, the primary server in each group
# # is considered to be the first unless any hosts have the primary
# # property set.  Don't declare `role :all`, it's a meta role.

# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}


# # Extended Server Syntax
# # ======================
# # This can be used to drop a more detailed server definition into the
# # server list. The second argument is a, or duck-types, Hash and is
# # used to set extended properties on the server.

# server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value


# # Custom SSH Options
# # ==================
# # You may pass any option but keep in mind that net/ssh understands a
# # limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
# #
# # Global options
# # --------------
# #  set :ssh_options, {
# #    keys: %w(/home/rlisowski/.ssh/id_rsa),
# #    forward_agent: false,
# #    auth_methods: %w(password)
# #  }
# #
# # And/or per server (overrides global)
# # ------------------------------------
# # server 'example.com',
# #   user: 'user_name',
# #   roles: %w{web app},
# #   ssh_options: {
# #     user: 'user_name', # overrides user setting above
# #     keys: %w(/home/user_name/.ssh/id_rsa),
# #     forward_agent: false,
# #     auth_methods: %w(publickey password)
# #     # password: 'please use keys'
# #   }
