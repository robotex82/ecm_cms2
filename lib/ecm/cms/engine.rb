module Ecm
  module Cms
    class Engine < ::Rails::Engine
      config.app_generators do |c|
        c.test_framework :rspec, :fixture => true,
                                 :fixture_replacement => nil

        c.integration_tool :rspec
        c.performance_tool :rspec
      end

      # active admin
      initializer :ecm_cms_engine do
        ::ActiveAdmin.setup do |config|
          config.load_paths += Dir[File.dirname(__FILE__) + '/active_admin']
          config.register_stylesheet 'ecm_cms.css'
          config.register_javascript 'ecm_cms.js'
        end
      end if defined?(::ActiveAdmin)

      initializer "ecm_cms.asset_pipeline" do |app|
        app.config.assets.precompile << 'ecm_cms.js'
        app.config.assets.precompile << 'ecm_cms.css'
      end
    end
  end
end

