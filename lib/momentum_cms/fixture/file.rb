module MomentumCms
  module Fixture
    module File
      class Importer < Base::Importer
        def import!(parent = nil, path = self.object_path)
          Dir["#{path}/**/"].each do |path|
            file_attributes = MomentumCms::Fixture::Utils.read_json(::File.join(path, 'attributes.json'), nil)
            next unless file_attributes

            file = MomentumCms::File.where(site: @site, identifier: file_attributes['identifier']).first_or_initialize
            file.site = @site
            file.label = file_attributes['label']
            file.identifier = file_attributes['identifier']

            begin
              file.file = ::File.open("#{path}/#{file_attributes['filename']}", 'rb')
            rescue
              file.file = nil
            end
            file.save!

            @imported_objects << file
          end

          MomentumCms::File.for_site(@site).where.not(id: @imported_objects.collect(&:id)).destroy_all if parent.nil?
        end
      end

      class Exporter < Base::Exporter
        def export!
          FileUtils.rm_rf(@export_path) if ::File.exist?(@export_path)
          FileUtils.mkdir_p(@export_path)
          export_files!(MomentumCms::File.for_site(@site))
        end

        def export_files!(files)
          files.each do |file|
            export_file!(file)
          end
        end

        def export_file!(file)
          file_path = ::File.join(@export_path, file.label.to_slug)
          attributes = {
            label: file.label,
            slug: file.slug,
            filename: file.file_file_name
          }

          MomentumCms::Fixture::Utils.write_json(::File.join(file_path, 'attributes.json'), attributes)
          MomentumCms::Fixture::Utils.write_file(::File.join(file_path, file.file_file_name), MomentumCms::Fixture::Utils.read_file(file.file.path))
        end
      end
    end
  end
end
