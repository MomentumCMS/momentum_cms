class MomentumCms::Fixture

  class Import

    def self.site(path)
      attributes = MomentumCms::Fixture::Utils.read_json(path)
      site = MomentumCms::Site.create!(label: attributes['label'], host: attributes['host'])
      pages_path = File.join(File.dirname(path), 'pages')
      MomentumCms::Fixture::Import.pages(site, pages_path)
    end

    def self.pages(site, path, parent = nil)
      pages = []
      puts Dir["#{path}*/"].inspect
      Dir["#{path}*/"].each do |path|
        if File.exists?(attrs_path = File.join(path, 'attributes.json'))

          # Fetch the attributes
          attributes = MomentumCms::Fixture::Utils.read_json(attrs_path)

          puts "=================================="
          puts "Path: #{path}"
          puts "Parent: #{parent.inspect}"
          puts "Attributes: #{attributes}"
          puts ""

          # Build the page
          page = site.pages.build(
            label:  attributes['label'],
            slug:   attributes['slug'],
            parent: parent
          )

          if page.save
            parent = page
          end

          # Recursivly call this function
          MomentumCms::Fixture::Import.pages(site, path, parent)

        end
      end
    end

  end

end