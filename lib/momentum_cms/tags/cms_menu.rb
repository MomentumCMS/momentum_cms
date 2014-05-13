module MomentumCms
  module Tags
    class CmsMenu < CmsBaseTag
  
      def render(context)
        _cms_page = context.environments.first
        _cms_page =_cms_page[:cms_page]
        menu = if @params.has_key?(:sub_menu_only)
                 _cms_page_children = _cms_page.children
                 menu = ''
                 menu += '<ul class="nav nav-sidebar">' if _cms_page_children.length > 0
                 _cms_page_children.each do |cms_page|
                   menu += "<li><a href='#{cms_page.path}'>#{cms_page.contents.first.label}</a></li>"
                 end
                 menu += '</ul>' if _cms_page_children.length > 0
                 menu.html_safe
               elsif @params.has_key?(:parent_page_only)
                 menu = ''

                 _cms_page_parent = _cms_page.parent
                 if _cms_page_parent
                   menu += '<ul class="nav nav-sidebar">'
                   menu += "<li><a href='#{_cms_page_parent.path}'>#{_cms_page_parent.contents.first.label}</a></li>"
                   menu += '</ul>'
                 end
                 menu.html_safe
               end
        menu

      rescue => e
        print_error_message(e, self, context, @params)
      end
    end

    Liquid::Template.register_tag 'cms_menu', CmsMenu
  end
end
