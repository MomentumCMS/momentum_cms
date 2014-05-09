class TemplateBlockService
  def initialize(template)
    @template           = template
    @template_ancestors = MomentumCms::Template.ancestor_and_self!(template)
  end

  def get_blocks(recursive = true)
    blocks = []
    if @template_ancestors && @template_ancestors.length > 0
      template  = @template_ancestors.shift
      liquid    = Liquid::Template.parse(template.content)
      node_list = liquid.root.nodelist
      node_list.each do |node|
        if node.is_a?(CmsBlockTag)
          blocks << node
        elsif recursive && node.is_a?(CmsYieldTag)
          blocks << get_blocks(@template_ancestors)
        end
      end
    end
    blocks.flatten
  end
end
