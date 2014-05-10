module MomentumCms
  module Fixture
    module Template
      class Importer < Base::Importer
        def import!(parent = nil, path = self.object_path)
          Dir["#{path}*/"].each do |path|
            template_attributes = MomentumCms::Fixture::Utils.read_json(::File.join(path, 'attributes.json'), nil)
            next unless template_attributes

            template = MomentumCms::Template.where(site: @site, label: template_attributes['label']).first_or_initialize
            template.parent = parent if parent
            template.content = MomentumCms::Fixture::Utils.read_file("#{path}/content.liquid", '')
            template.js = MomentumCms::Fixture::Utils.read_file("#{path}/content.js", '')
            template.css = MomentumCms::Fixture::Utils.read_file("#{path}/content.css", '')
            # Save the template
            template.save!

            @imported_objects << template
            import!(template, path)
          end
          MomentumCms::Template.for_site(@site).where.not(id: @imported_objects.collect(&:id)).destroy_all if parent.nil?
        end
      end

      class Exporter < Base::Exporter
        def export!
          FileUtils.rm_rf(@export_path) if ::File.exist?(@export_path)
          FileUtils.mkdir_p(@export_path)
          export_templates!(MomentumCms::Template.roots.for_site(@site))
        end

        def export_templates!(templates)
          templates.each do |template|
            export_template!(template)
            export_templates!(template.children)
          end
        end

        def get_template_path(template)
          template_array = [template.ancestors, template].flatten
          template_array.shift
          template_array.collect { |x| x.label.to_slug }.join('/')
        end

        def export_template!(template)
          template_path = ::File.join(@export_path, get_template_path(template))

          FileUtils.mkdir_p(template_path)
          attributes = {
            label: template.label
          }
          MomentumCms::Fixture::Utils.write_json(::File.join(template_path, 'attributes.json'), attributes)
          MomentumCms::Fixture::Utils.write_file(::File.join(template_path, 'content.liquid'), template.content)
          MomentumCms::Fixture::Utils.write_file(::File.join(template_path, 'content.css'), template.css)
          MomentumCms::Fixture::Utils.write_file(::File.join(template_path, 'content.js'), template.js)
        end
      end
    end
  end
end
