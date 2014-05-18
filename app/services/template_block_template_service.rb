class TemplateBlockTemplateService

  attr_accessor :template_ancestors

  def initialize(template)
    @template = template
  end

  def create_or_update_block_templates_for_self!(delete_orphan = true)
    created_block_templates = []
    liquid = Liquid::Template.parse(@template.value)
    node_list = liquid.root.nodelist
    node_list.each do |node|
      if node.is_a?(MomentumCms::Tags::CmsBlock)
        block_template = MomentumCms::BlockTemplate.where(template: @template,
                                                          identifier: node.params['id']).first_or_create!
        created_block_templates << block_template
      end
    end
    if delete_orphan
      MomentumCms::BlockTemplate.where(template: @template).where.not(id: created_block_templates.collect(&:id)).destroy_all
    end

    created_block_templates
  end

end
