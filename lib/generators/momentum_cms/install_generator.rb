module MomentumCms
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      class_option :model, optional: true, type: :string, banner: 'model',
                   desc: "Specify the model class name if you will use anything other than 'MomentumCms::User'"

      desc 'Creating initializer files'

      def create_initializer_file
        copy_file 'momentum_cms.rb', 'config/initializers/momentum_cms.rb'
      end

      desc 'Copies migrations to your application.'

      def copy_migrations
        rake('momentum_cms_engine:install:migrations')

        if defined?(MomentumCmsUserManagement)
          rake('momentum_cms_user_management_engine:install:migrations')
          gsub_file 'config/initializers/momentum_cms.rb', /#{Regexp.escape('# config.admin_authentication')}/mi do
            <<-RUBY
            #Using MomentumCmsUserManagement Engine for user management
            config.admin_authentication = MomentumCmsUserManagement::Authentication::UserManagementAuthentication
            RUBY
          end
        end
      end
    end
  end
end