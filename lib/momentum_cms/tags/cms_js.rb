module MomentumCms
  module Tags
    class CmsJsTag < CmsBaseTag

      def render(context)
        _cms_page_id = context.environments.first[:cms_page].id
        stylesheet_link_tag "/momentum_cms/js/#{_cms_page_id}.js"
      rescue
        ''
      end
    end

    Liquid::Template.register_tag 'cms_js', CmsJsTag
  end
end
