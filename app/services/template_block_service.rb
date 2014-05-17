class TemplateBlockService

  attr_accessor :template_ancestors

  def initialize(template)
    @template = template
    @template_ancestors = MomentumCms::Template.ancestor_and_self!(template)
  end

  def get_template_blocks(list = self.template_ancestors.dup)
    blocks = []
    if list && list.length > 0
      template = list.shift
      liquid = Liquid::Template.parse(template.content)
      node_list = liquid.root.nodelist
      node_list.each do |node|
        if node.is_a?(MomentumCms::Tags::CmsBlock)
          blocks << { template: template, block: node }
        elsif  node.is_a?(MomentumCms::Tags::CmsYield)
          blocks << get_blocks(list)
        end
      end
    end
    blocks.flatten
  end

  def get_blocks(list = self.template_ancestors.dup)
    blocks = []
    if list && list.length > 0
      template = list.shift
      liquid = Liquid::Template.parse(template.content)
      node_list = liquid.root.nodelist
      node_list.each do |node|
        if node.is_a?(MomentumCms::Tags::CmsBlock)
          blocks << node
        elsif  node.is_a?(MomentumCms::Tags::CmsYield)
          blocks << get_blocks(list)
        end
      end
    end
    blocks.flatten
  end
end
