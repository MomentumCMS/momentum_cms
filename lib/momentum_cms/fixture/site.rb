module MomentumCms::Fixture::Site

  class Importer

    def initialize(site_directory)
      @site_path = File.join(MomentumCms.config.site_fixtures_path, site_directory)
      @attributes = MomentumCms::Fixture::Utils.read_json(File.join(@site_path, 'attributes.json'))
    end

    def import!
      site = MomentumCms::Site.where(identifier: @attributes['identifier']).first_or_initialize
      site.label = @attributes['label']
      site.host = @attributes['host']
      if @attributes['locales']
        site.settings(:language).locales = @attributes['locales']
      end
      site.save!
      site
    end

  end

  class Exporter

    def initialize(site, site_directory)
      @site = site
      @site_path = File.join(MomentumCms.config.site_fixtures_path, site_directory)
    end

    def export!
      FileUtils.rm_rf(@site_path) if File.exist?(@site_path)
      FileUtils.mkdir_p(@site_path) unless File.exist?(@site_path)
      attributes = {
        label: @site.label,
        host: @site.host,
        identifier: @site.identifier,
        locales: [@site.settings(:language).locales].flatten
      }
      MomentumCms::Fixture::Utils.write_json(File.join(@site_path, 'attributes.json'), attributes)
    end

  end

end