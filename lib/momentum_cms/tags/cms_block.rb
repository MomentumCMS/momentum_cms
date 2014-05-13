module MomentumCms
  module Tags

    class CmsBlock < CmsBaseTag
      def render(context)
        cms_content = context_get(context, :cms_content)
        raise CmsTagError.new(':cms_content was not passed in the rendering context') unless cms_content

        id = @params.fetch(:id, nil)
        raise CmsTagError.new(':id was not passed in the cms_block tag') unless id

        block = cms_content.blocks.where(identifier: id).first
        raise CmsTagError.new('Block not found') unless block

        template = Liquid::Template.parse(block.value)
        template.render(context)
      rescue => e
        print_error_message(e, self, context, @params)
      end
    end
    Liquid::Template.register_tag 'cms_block', CmsBlock
  end
end