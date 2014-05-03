module MomentumCms::Fixture::Site

  class Importer

    def initialize(site_directory)
      @site_path = File.join(MomentumCms.config.site_fixtures_path, site_directory)
      @attributes = MomentumCms::Fixture::Utils.read_json(File.join(@site_path, 'attributes.json'))
    end

    def import!
      return MomentumCms::Site.where(label: @attributes['label'], host: @attributes['host']).first_or_create
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
        host:  @site.host
      }
      MomentumCms::Fixture::Utils.write_json(File.join(@site_path, 'attributes.json'), attributes)
    end

  end

end