module MomentumCms::Fixture::Page

  class Importer

    attr_accessor :pages_path,
                  :pages_hash

    def initialize(site, pages_path)
      @site = site
      @pages_path = File.join(MomentumCms.config.site_fixtures_path, pages_path)
    end

    def import!
      @pages_hash = {}

      Dir["#{@pages_path}*/"].each do |path|
        add_page(@pages_hash, path)
        build_page_tree(@pages_hash, path)
      end

      # TODO: Consider locales and how we structure that within the json data
      locale = :en
      @pages_hash.each do |path, page_attributes|

        # Genreate the expected path
        expected_path = generate_path(path, page_attributes, locale)
        
        # Check if this already exists in the database
        page = MomentumCms::Page.where(site: @site, path: expected_path).first_or_initialize
        page.label = page_attributes['label']
        page.slug  = page_attributes['slug']

        # Set the parent if required
        if has_parent?(path)
          parent_path = parent_path(path)
          parent_attributes = @pages_hash[parent_path]
          expected_path = generate_path(parent_path, parent_attributes)
          parent = MomentumCms::Page.where(site: @site, path: expected_path).first
          page.parent = parent if parent
        end

        # Save the page
        page.save!

      end

    end

    def add_page(pages, page_path)
      attributes_path = File.join(page_path, 'attributes.json')
      if File.exists?(attributes_path)
        pages[page_path] = MomentumCms::Fixture::Utils.read_json(attributes_path)
      end
    end

    def build_page_tree(pages, path)
      Dir["#{path}*/"].each do |path|
        add_page(pages, path)
        build_page_tree(pages, path)
      end
    end

    def generate_path(path, attributes, locale = nil)
      full_path = []
      full_path << attributes['slug']
      ancestors(path).each do |ancestor|
        full_path << ancestor['slug']
      end
      expected_path = '/' + full_path.reverse.join('/')
      # Remove any double slashes.
      expected_path.gsub(/(\/{2,})/,'/')
    end

    def ancestors(path, pages = [])
      if has_parent?(path)
        pages << @pages_hash[parent_path(path)]
        ancestors(parent_path(path), pages)
      else
        return pages
      end
    end

    def has_parent?(path)
      @pages_hash.has_key?(parent_path(path))
    end

    def parent_path(path)
      path = path.split('/')
      path.pop
      File.join(path) + '/'
    end

  end

  class Exporter

    def initialize(pages, export_path)
      @pages = pages
      @export_path = File.join(MomentumCms::config.site_fixtures_path, export_path)
    end

    def export!
      FileUtils.rm_rf(@export_path) if File.exist?(@export_path)
      FileUtils.mkdir_p(@export_path) unless File.exist?(@export_path)
      export_pages(@pages)
    end

    def export_pages(pages)
      pages.each do |page, children|
        export_page(page)
        export_pages(children)
      end
    end

    def export_page(page)
      page_path = File.join(@export_path, page.path)
      FileUtils.mkdir_p(page_path)
      attributes = {
        label: page.label,
        slug:  page.slug
      }
      MomentumCms::Fixture::Utils.write_json(File.join(page_path, 'attributes.json'), attributes)
    end


  end

end