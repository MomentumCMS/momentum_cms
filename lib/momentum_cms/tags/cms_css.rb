module MomentumCms
  module Tags
    class CmsCssTag < CmsBaseTag

      def render(context)
        _cms_page_id = context.environments.first[:cms_page].id
        stylesheet_link_tag "/momentum_cms/css/#{_cms_page_id}.css"
      rescue
        ''
      end
    end

    Liquid::Template.register_tag 'cms_css', CmsCssTag
  end
end
