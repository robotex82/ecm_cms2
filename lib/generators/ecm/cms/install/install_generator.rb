module Ecm
  module Cms
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc 'Generates the initializer'

        source_root File.expand_path('../templates', __FILE__)

        def generate_initializer
          copy_file 'initializer.rb', 'config/initializers/ecm_cms.rb'
        end

        def generate_controller
          copy_file 'frontend_controller.rb', 'app/controllers/frontend_controller.rb'
        end

        def generate_routes
          inject_into_file 'config/routes.rb', before: "\nend" do
            File.read(File.join(File.expand_path('../templates', __FILE__), 'routes.source'))
          end
        end

        # def add_homepages
        #   if yes? "Do you want to add homepages?"
        #     AddHomepagesService.call
        #   end
        # end
      end
    end
  end
end
