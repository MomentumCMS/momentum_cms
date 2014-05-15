module MomentumCms
  module Fixture
    module Menu
      class Importer < Base::Importer
        def import!(parent = nil, path = self.object_path)
          Dir["#{path}/**/"].each do |path|
            menu_attributes = MomentumCms::Fixture::Utils.read_json(::File.join(path, 'attributes.json'), nil)
            next unless menu_attributes

            menu = MomentumCms::Menu.where(site: @site, slug: menu_attributes['slug']).first_or_initialize
            menu.site = @site
            menu.label = menu_attributes['label']
            menu.slug = menu_attributes['slug']

            # begin
            #   menu.menu = ::Menu.open("#{path}/#{menu_attributes['menuname']}", 'rb')
            # rescue
            #   menu.menu = nil
            # end
            menu.save!

            @imported_objects << menu
          end

          MomentumCms::Menu.for_site(@site).where.not(id: @imported_objects.collect(&:id)).destroy_all if parent.nil?
        end
      end

      class Exporter < Base::Exporter
        def export!
          FileUtils.rm_rf(@export_path) if ::File.exist?(@export_path)
          FileUtils.mkdir_p(@export_path)
          export_menus!(MomentumCms::Menu.for_site(@site))
        end

        def export_menus!(menus)
          menus.each do |menu|
            export_menu!(menu)
          end
        end

        def export_menu!(menu)
          menu_path = ::File.join(@export_path, menu.label.to_slug)
          attributes = {
            label: menu.label,
            slug: menu.slug,
          }

          MomentumCms::Fixture::Utils.write_json(::File.join(menu_path, 'attributes.json'), attributes)
        end
      end
    end
  end
end
