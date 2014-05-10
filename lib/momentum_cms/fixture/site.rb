module MomentumCms
  module Fixture
    module Site
      class Importer < Base::Importer

        def initialize(source, site = nil)
          @site_path = ::File.join(MomentumCms.config.site_fixtures_path, source)
          @attributes = MomentumCms::Fixture::Utils.read_json(::File.join(@site_path, 'attributes.json'))
          @site_identifier = site || @attributes['identifier']

          raise StandardError.new('Expecting attributes.json identifier to be defined, or a site identifier passed in.') if @site_identifier.empty?
        end

        def import!
          site = MomentumCms::Site.where(identifier: @site_identifier).first_or_initialize
          site.label = @attributes['label']
          site.host = @attributes['host']
          if @attributes['locales']
            site.settings(:language).locales = @attributes['locales']
          end
          site.save!
          site
        end

      end

      class Exporter < Base::Exporter
        def export!
          FileUtils.rm_rf(@export_path) if ::File.exist?(@export_path)
          FileUtils.mkdir_p(@export_path)
          attributes = {
            label: @site.label,
            host: @site.host,
            identifier: @site.identifier,
            locales: [@site.settings(:language).locales].flatten
          }
          MomentumCms::Fixture::Utils.write_json(::File.join(@export_path, 'attributes.json'), attributes)
        end
      end
    end
  end
end
