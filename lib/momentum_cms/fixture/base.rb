module MomentumCms
  module Fixture
    module Base
      class Importer
        attr_accessor :object_path
        attr_accessor :imported_objects

        def initialize(from, site)
          @imported_objects = []
          @site = site

          object_folder =
            case self
              when MomentumCms::Fixture::Page::Importer
                'pages'
              when MomentumCms::Fixture::Template::Importer
                'templates'
            end
          @object_path = ::File.join(MomentumCms.config.site_fixtures_path, ::File.join(from, object_folder))
        end

        def import!
        end
      end

      class Exporter
        def initialize
        end

        def export!
        end
      end
    end
  end
end