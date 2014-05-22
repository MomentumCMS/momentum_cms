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


  def create_or_update_block_templates_for_self!(delete_orphan = true)
    created_block_templates = []
    tbs = TemplateBlockService.new(@template)
    tbs.each_node do |node|
      if node.is_a?(MomentumCms::Tags::CmsBlock)
        block_template = MomentumCms::BlockTemplate.where(template: @template,
                                                          identifier: node.params['id']).first_or_initialize
        block_template.block_value_type = node.params.fetch('type', nil)
        block_template.save!
        created_block_templates << block_template
      end
    end

    if delete_orphan
      MomentumCms::BlockTemplate.where(template: @template).where.not(id: created_block_templates.collect(&:id)).destroy_all
    end

    created_block_templates
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

  def has_block?(type)
    has_block_type = false
    self.each_node do |node|
      if node.is_a?(type)
        has_block_type = true
      end
    end
    has_block_type
  end

  def get_blocks(list = self.template_ancestors.dup)
    blocks = []
    list.each do |template|
      blocks << template.block_templates.to_a
    end
    blocks.flatten.compact
  end
end
