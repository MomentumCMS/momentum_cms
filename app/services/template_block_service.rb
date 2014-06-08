class TemplateBlockService

  attr_accessor :template_ancestors
  attr_accessor :template

  def initialize(template)
    @template = template
    @template_ancestors = MomentumCms::Template.ancestor_and_self!(template)

    @valid_template = Liquid::Template.parse(@template.value)
  rescue Liquid::SyntaxError
    @valid_template = nil
  end

  def create_or_update_field_templates_for_self!(delete_orphan = true)
    created_field_templates = []
    self.each_node do |node|
      next unless node.is_a?(MomentumCms::Tags::CmsBlock)
      field_template = MomentumCms::FieldTemplate.where(layout: @template,
                                                        identifier: node.params['id']).first_or_create! do |o|
        o.field_value_type = node.params.fetch('type', nil)
      end

      MomentumCms::Fixture::Utils.each_locale_for_site(@template.site) do |locale|
        label = node.params_get(locale.to_s)
        if label
          field_template.label = label
          field_template.save
        end
      end
      created_field_templates << field_template
    end

    if delete_orphan
      MomentumCms::FieldTemplate.where(layout: @template).where.not(id: created_field_templates.collect(&:id)).destroy_all
    end

    created_field_templates
  end

  def valid_liquid?
    !@valid_template.nil?
  end

  def each_node(template = self.template)
    node_list = if template
                  begin
                    liquid = Liquid::Template.parse(template.value)
                    liquid.root.nodelist
                  rescue Liquid::SyntaxError
                    []
                  end
                elsif @valid_template
                  @valid_template.root.nodelist
                else
                  []
                end
    node_list.each do |node|
      yield(node)
    end
  end

  def has_field?(type)
    has_field_type = false
    self.each_node do |node|
      if node.is_a?(type)
        has_field_type = true
      end
    end
    has_field_type
  end

  def get_fields(list = self.template_ancestors.dup)
    fields = []
    list.each do |template|
      fields << template.field_templates.to_a
    end
    fields.flatten.compact
  end
end