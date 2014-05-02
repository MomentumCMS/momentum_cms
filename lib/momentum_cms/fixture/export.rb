module MomentumCms::Fixture

  class Export

    def self.site(path, site)
      FileUtils.mkdir_p(path) unless File.exist?(path)
      attributes = {
        label: site.label,
        host:  site.host
      }
      write_path = File.join(path, 'attributes.json')
      MomentumCms::Fixture::Utils.write_json(write_path, attributes)
    end

  end

end