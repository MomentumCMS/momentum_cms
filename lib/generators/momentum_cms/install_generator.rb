module MomentumCms
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_initializer_file
        copy_file 'momentum_cms.rb', 'config/initializers/momentum_cms.rb'
      end
    end
  end
end