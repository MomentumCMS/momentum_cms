module MomentumCms::Fixture::Template

  class Importer

    attr_accessor :templates_path,
                  :templates_hash

    def initialize(site, templates_path)
      @site           = site
      @templates_path = File.join(MomentumCms.config.site_fixtures_path, templates_path)
    end

    def import!
      @templates_hash = {}
      Dir["#{@templates_path}/**/"].each do |path|
        add_template(@templates_hash, path)
      end

      @templates_hash.sort_by { |k, v| k }.each do |path, template_attributes|

        template = MomentumCms::Template.where(site: @site, label: template_attributes['label']).first_or_initialize
        if has_parent?(path)
          parent_path       = parent_path(path)
          parent_attributes = @templates_hash[parent_path]
          parent            = MomentumCms::Template.where(site: @site, id: parent_attributes[:id]).first
          template.parent   = parent if parent
        end

        if File.file?("#{path}/content.liquid")
          template.content = MomentumCms::Fixture::Utils.read_file("#{path}/content.liquid")
        end

        if File.file?("#{path}/content.js")
          template.js = MomentumCms::Fixture::Utils.read_file("#{path}/content.js")
        end

        if File.file?("#{path}/content.css")
          template.css = MomentumCms::Fixture::Utils.read_file("#{path}/content.css")
        end

        # Save the template
        template.save!
        @templates_hash[path].merge!({ id: template.id })
      end
    end

    def add_template(templates, template_path)
      attributes_path = File.join(template_path, 'attributes.json')
      if File.exists?(attributes_path)
        templates[template_path] = MomentumCms::Fixture::Utils.read_json(attributes_path)
      end
    end

    def has_parent?(path)
      @templates_hash.has_key?(parent_path(path))
    end

    def parent_path(path)
      path = path.split('/')
      path.pop
      path.join('/') + '/'
    end

  end

  class Exporter
    def export!
    end
  end
end