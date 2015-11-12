module B1Admin
  class Engine < ::Rails::Engine


    initializer :add_view_paths do
      views = paths["app/views"].existent
      unless views.empty?
        ActiveSupport.on_load(:action_controller){ prepend_view_path(views) if respond_to?(:prepend_view_path) }
        ActiveSupport.on_load(:action_mailer){ prepend_view_path(views) }
      end
    end

    isolate_namespace B1Admin

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :haml
      g.test_framework  :rspec
      g.helper false
      g.assets false
      g.view_specs false
    end
    config.action_controller.perform_caching = true
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |path|
          app.config.paths["db/migrate"] << path
        end
      end
    end
    config.autoload_paths += Dir[config.root.join('app', 'serializers', '{**}')]
    config.autoload_paths += Dir[config.root.join('app', 'controllers/b1_admin/concerns/', '*.{rb}')]
    config.i18n.enforce_available_locales = false
    config.assets.paths << config.root.join("app", "assets", "fonts")
    config.assets.precompile += %w( b1_admin/login.css b1_admin/login.js)
    config.i18n.load_path += Dir[config.root.join('locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru
    ::B1Config.add_load_path "#{config.root}/config/configs"
  end
end
