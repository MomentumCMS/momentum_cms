module MomentumCms
  module Tags

    class CmsBlock < CmsBaseTag
      def render(context)
        cms_content = context_get(context, :cms_content)
        return '' unless cms_content
        value = cms_content.blocks.where(identifier: @params[:id]).first!.value

        template = Liquid::Template.parse(value)
        template.render(context)

      rescue
        ''
      end
    end
    Liquid::Template.register_tag 'cms_block', CmsBlock
  end
end