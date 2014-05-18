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
    if list && list.length > 0
      template = list.shift
      self.each_node(template) do |node|
        if node.is_a?(MomentumCms::Tags::CmsBlock)
          blocks << node
        elsif node.is_a?(MomentumCms::Tags::CmsYield)
          blocks << get_blocks(list)
        end
      end
    end
    blocks.flatten
  end
end
