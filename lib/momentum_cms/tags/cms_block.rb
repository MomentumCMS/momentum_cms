module MomentumCms
  module Tags

    class CmsBlock < CmsBaseTag

      def render(context)
        _env = context.environments.first
        _edit = _env[:_edit]
        _cms_content = _env[:cms_content]
        if _edit
        else
          block = _cms_content.blocks.where(identifier: @params[:id]).first
          block.value
        end
      rescue
        ''
      end
    end

    Liquid::Template.register_tag 'cms_block', CmsBlock
  end
end