module MomentumCms
  module Fixture
    module Snippet
      class Importer < Base::Importer
        def import!(parent = nil, path = self.object_path)
          Dir["#{path}/**/"].each do |path|
            snippet_attributes = MomentumCms::Fixture::Utils.read_json(::File.join(path, 'attributes.json'), nil)
            next unless snippet_attributes

            snippet = MomentumCms::Snippet.where(site: @site, slug: snippet_attributes['slug']).first_or_initialize
            snippet.site = @site
            snippet.label = snippet_attributes['label']
            snippet.slug = snippet_attributes['slug']

            MomentumCms::Fixture::Utils.each_locale_for_site(@site) do |locale|
              snippet.value = MomentumCms::Fixture::Utils.read_file("#{path}/#{locale}/content.html", '')
              snippet.save!
            end

            @imported_objects << snippet
          end

          MomentumCms::Snippet.for_site(@site).where.not(id: @imported_objects.collect(&:id)).destroy_all if parent.nil?
        end
      end

      class Exporter < Base::Exporter
        def export!
          FileUtils.rm_rf(@export_path) if ::File.exist?(@export_path)
          FileUtils.mkdir_p(@export_path)
          export_snippets!(MomentumCms::Snippet.for_site(@site))
        end

        def export_snippets!(snippets)
          snippets.each do |snippet|
            export_snippet!(snippet)
          end
        end

        def export_snippet!(snippet)
          snippet_path = ::File.join(@export_path, snippet.label.to_slug)
          attributes = {
            label: snippet.label,
            slug: snippet.slug
          }

          MomentumCms::Fixture::Utils.write_json(::File.join(snippet_path, 'attributes.json'), attributes)
          MomentumCms::Fixture::Utils.each_locale_for_site(@site) do |locale|
            MomentumCms::Fixture::Utils.write_file(::File.join(snippet_path, locale, 'content.html'), snippet.value)
          end
        end
      end
    end
  end
end
