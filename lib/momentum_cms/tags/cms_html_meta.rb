module MomentumCms
  module Tags
    class CmsHtmlMeta < CmsBaseTag

      def initialize(tag_name, params, tokens)
        super

        @params[:type] = 'css' if tag_name == 'cms_css'
        @params[:type] = 'js' if tag_name == 'cms_js'
      end

      def render(context)
        page = context_get(context, :cms_page)

        return '' unless page

        case @params[:type]
          when 'js'
            javascript_include_tag "/momentum_cms/js/#{page.id}.js"
          when 'css'
            stylesheet_link_tag "/momentum_cms/css/#{page.id}.css"
          else
            ''
        end
      end
    end
    Liquid::Template.register_tag 'cms_html_meta', CmsHtmlMeta
    Liquid::Template.register_tag 'cms_css', CmsHtmlMeta
    Liquid::Template.register_tag 'cms_js', CmsHtmlMeta
  end
end
