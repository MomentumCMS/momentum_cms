module MomentumCms
  module Fixture
    module Page
      class Importer < Base::Importer

        def get_page(site, parent, slug, label)
          if parent
            scope = MomentumCms::Page.for_site(site).children_of(parent)
            scope.where(slug: slug).first || scope.where(label: label).first_or_initialize
          else
            MomentumCms::Page.for_site(site).roots.first_or_initialize
          end
        end

        def import!(parent = nil, path = self.object_path)
          Dir["#{path}*/"].each do |path|

            page_attributes = MomentumCms::Fixture::Utils.read_json(::File.join(path, 'attributes.json'), nil)
            next unless page_attributes

            next_parent = nil

            MomentumCms::Fixture::Utils.each_locale_for_site(@site) do |locale|
              # Get the slug
              slug = slug_for_locale(page_attributes, locale)

              # Check if this already exists in the database
              # TODO: Limitation There can ever be only 1 root page
              page = get_page(@site, parent, slug, page_attributes['label'])

              # Set the parent if required
              # page.site = @site
              page.parent = parent if parent
              page.label = page_attributes['label']
              page.identifier = page_attributes['identifier']
              page.slug = slug
              page.template = MomentumCms::Template.for_site(@site).where(identifier: page_attributes['template']).first

              # Save the page
              page.save!
              @imported_objects << page
              # Attach any page content/blocks
              prepare_content(page, path)
              next_parent = page
            end

            import!(next_parent, path)
          end

          MomentumCms::Page.for_site(@site).where.not(id: @imported_objects.collect(&:id)).destroy_all if parent.nil?
        end

        def prepare_content(page, path)
          cms_content = MomentumCms::Content.where(page: page, label: page.label).first_or_initialize
          cms_content.save!

          page.published_content_id = cms_content.id
          page.save!

          Dir.glob("#{path}/*.liquid").each do |content_path|
            text = ::File.read(content_path)
            template = Liquid::Template.parse(text)


            original_locale = I18n.locale
            template.root.nodelist.each do |node|
              next unless node.is_a?(MomentumCms::Tags::CmsFixture)


              I18n.locale = node.params['locale']
              cms_template = MomentumCms::Template.for_site(@site).where(identifier: node.params['template']).first

              cms_block = MomentumCms::Block.where(content: cms_content, identifier: node.params['id']).first_or_initialize
              cms_block.value = MomentumCms::Tags::CmsFixture.get_contents(node)
              cms_block.block_template = MomentumCms::BlockTemplate.where(template: cms_template, identifier: node.params['id']).first
              cms_block.save!
            end
            I18n.locale = original_locale
          end
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
      end

      class Exporter < Base::Exporter
        def export!
          FileUtils.rm_rf(@export_path) if ::File.exist?(@export_path)
          FileUtils.mkdir_p(@export_path)
          export_pages!(MomentumCms::Page.roots.for_site(@site))
        end

        def export_pages!(pages)
          pages.each do |page|
            export_page!(page)
            export_pages!(page.children)
          end
        end

        def export_page!(page)
          page_path = ::File.join(@export_path, page.path)
          attributes = {
            label: page.label,
            slug: page.slug,
            template: page.template.identifier
          }
          MomentumCms::Fixture::Utils.write_json(::File.join(page_path, 'attributes.json'), attributes)
        end
      end
    end
  end
end
