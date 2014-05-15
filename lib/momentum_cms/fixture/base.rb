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
              when MomentumCms::Fixture::Snippet::Importer
                'snippets'
              when MomentumCms::Fixture::File::Importer
                'files'
              when MomentumCms::Fixture::Menu::Importer
                'menus'
            end
          @object_path = ::File.join(MomentumCms.config.site_fixtures_path, ::File.join(from, object_folder))
        end

        def import!
        end
      end

      class Exporter
        attr_accessor :export_path

        def initialize(target, site)
          @site = site
          object_folder =
            case self
              when MomentumCms::Fixture::Page::Exporter
                'pages'
              when MomentumCms::Fixture::Template::Exporter
                'templates'
              when MomentumCms::Fixture::Snippet::Exporter
                'snippets'
              when MomentumCms::Fixture::File::Exporter
                'files'
              when MomentumCms::Fixture::Menu::Exporter
                'menus'
              else
                ''
            end
          @export_path = ::File.join(MomentumCms.config.site_fixtures_path, ::File.join(target, object_folder))
        end
      end
    end
  end
end
