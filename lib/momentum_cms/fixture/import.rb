class MomentumCms::Fixture

  class Import

    def self.site(path)
      attributes = MomentumCms::Fixture::Utils.read_json(path)
      site = MomentumCms::Site.create!(label: attributes['label'], host: attributes['host'])
      pages_path = File.join(File.dirname(path), 'pages')
      MomentumCms::Fixture::Import.pages(site, pages_path)
    end

    def self.pages(site, path, parent = nil)
      Dir["#{path}*/"].each do |path|
        if File.exists?(attrs_path = File.join(path, 'attributes.json'))

          # Fetch the attributes
          attributes = MomentumCms::Fixture::Utils.read_json(attrs_path)

          # Determine the parent
          unless MomentumCms::Fixture::Import.is_parent?(parent, path)
            parent = MomentumCms::Fixture::Import.get_parent(path)
          end

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

    def self.is_parent?(page, path)
      parent_path = File.expand_path('..', path)
      if File.exists?(attrs_path = File.join(parent_path, 'attributes.json'))
        attributes = MomentumCms::Fixture::Utils.read_json(attrs_path)
        if attributes['slug'].present? && page.slug == attributes['slug']
          is_parent = true
        end
      end
      is_parent
    end

    # TODO: I believe there is a situation where pages with duplicate slugs
    # could result in a malformed tree, although the tests seem to pass
    # without issue
    def self.get_parent(path)
      parent_path = File.expand_path('..', path)
      if File.exists?(attrs_path = File.join(parent_path, 'attributes.json'))
        attributes = MomentumCms::Fixture::Utils.read_json(attrs_path)
        return MomentumCms::Page.find_by(slug: attributes['slug'])
      end
    end

  end

end