module MomentumCms
  module Tags
    class CmsHtmlMeta < CmsBaseTag

      def initialize(tag_name, params, tokens)
        super
        @params[:type] = 'css' if tag_name == 'cms_css'
        @params[:type] = 'js' if tag_name == 'cms_js'
      end

      def render(context)
        cms_page = context_get(context, :cms_page)
        raise CmsTagError.new(':cms_page was not passed in the rendering context') unless cms_page
        
        case @params[:type]
          when 'js'
            javascript_include_tag "/momentum_cms/js/#{cms_page.id}.js"
          when 'css'
            stylesheet_link_tag "/momentum_cms/css/#{cms_page.id}.css"
          else
            ''
        end
      rescue => e
        print_error_message(e, self, context, @params)
      end
    end
    Liquid::Template.register_tag 'cms_html_meta', CmsHtmlMeta
    Liquid::Template.register_tag 'cms_css', CmsHtmlMeta
    Liquid::Template.register_tag 'cms_js', CmsHtmlMeta
  end
end
