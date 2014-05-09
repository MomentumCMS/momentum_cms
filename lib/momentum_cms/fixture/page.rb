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

      Dir["#{@pages_path}/**/"].each do |path|
        add_page(@pages_hash, path)
      end

      original_locale = :en
      locales = [:en]
      locales = @site.settings(:language).locales if @site.settings(:language).locales.present?
      locales.each do |locale|
        # Set the Locale
        I18n.locale = locale

        @pages_hash.sort_by { |k, v| k }.each do |path, page_attributes|

          # Generate the expected path
          internal_path = generate_internal_path(path, page_attributes)

          # Check if this already exists in the database
          page = MomentumCms::Page.where(site: @site, internal_path: internal_path).first_or_initialize
          page.label = page_attributes['label']
          page.slug = slug_for_locale(page_attributes, locale)

          if page_attributes['template']
            template = MomentumCms::Template.where(site: @site, label: page_attributes['template']).first
            if template
              page.template = template
            end
          end

          # Set the parent if required
          parent = get_parent_by_path(path)
          page.parent = parent if parent
          

          # Save the page
          page.save!

          # Attach any page content/blocks
          prepare_content(page, path)
        end
      end
      I18n.locale = original_locale
    end

    def get_parent_by_path(path)
      if has_parent?(path)
        parent_path = parent_path(path)
        parent_attributes = @pages_hash[parent_path]
        internal_path = generate_internal_path(parent_path, parent_attributes)
        MomentumCms::Page.where(site: @site, internal_path: internal_path).first
      end
    end

    def prepare_content(page, path)
      content = page.contents.build(label: page.label)
      Dir.glob("#{path}/*.liquid").each do |content_path|
        text = File.read(content_path)
        template = Liquid::Template.parse(text)
        original_locale = I18n.locale
        template.root.nodelist.each do |node|
          next unless node.is_a?(CmsFixtureBlockTag)
          I18n.locale = node.params[:locale]
          block = content.blocks.detect { |b| b.identifier == node.params[:id] }
          block = content.blocks.build(identifier: node.params[:id]) unless block
          block.value = node.nodelist.first
        end
        I18n.locale = original_locale
      end
      content.save! if content.blocks.present?
    end

    def add_page(pages, page_path)
      attributes_path = File.join(page_path, 'attributes.json')
      if File.exists?(attributes_path)
        pages[page_path] = MomentumCms::Fixture::Utils.read_json(attributes_path)
      end
    end

    def generate_path(path, attributes, locale = nil)
      full_path = []
      full_path << slug_for_locale(attributes, locale)
      ancestors(path).each do |ancestor|
        full_path << slug_for_locale(ancestor, locale)
      end
      expected_path = '/' + full_path.reverse.join('/')
      # Remove any double slashes.
      expected_path.gsub(/(\/{2,})/, '/')
    end

    def generate_internal_path(path, attributes)
      internal_path = []
      internal_path << attributes['label'].to_slug
      ancestors(path).each do |ancestor_attributes|
        internal_path << ancestor_attributes['label'].to_slug
      end
      internal_path = '/' + internal_path.reverse.join('/')
      internal_path.gsub(/(\/{2,})/, '/')
    end

    def slug_for_locale(attributes, locale = nil)
      locale = locale.to_s if locale
      slug = unless locale && attributes.has_key?('locales')
               attributes['slug']
             else
               attributes.fetch('locales', {}).fetch(locale, {}).fetch('slug', nil)
             end
      slug
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
      @pages_hash.has_key?(parent_path(path)) && path != '/'
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
        slug: page.slug
      }
      MomentumCms::Fixture::Utils.write_json(File.join(page_path, 'attributes.json'), attributes)
    end


  end

end