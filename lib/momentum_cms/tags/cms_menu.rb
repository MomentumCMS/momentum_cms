module MomentumCms
  module Tags
    class CmsMenu < CmsBaseTag

      def build_menu(menus = [], parent = nil, options = {})
        outer_tag = options.fetch(:outer_tag, nil)
        outer_class = options.fetch(:outer_class, nil)
        nested_outer_class = options.fetch(:nested_outer_class, nil)
        inner_tag = options.fetch(:inner_tag, nil)
        inner_class = options.fetch(:inner_class, nil)
        content_tag outer_tag.to_sym, class: (parent.nil? ? outer_class : nested_outer_class) do
          menus.collect do |menu_item|
            content_tag inner_tag.to_sym, class: inner_class do
              if menu_item.children
                content_tag(:a, menu_item.linkable.published_content.label, href: menu_item.linkable.path) +
                  build_menu(menu_item.children, menu_item, options)
              else
                content_tag(:a, menu_item.linkable.published_content.label, href: menu_item.linkable.path)
              end
            end
          end.join('').html_safe
        end
      end

      def render(context)
        cms_site = context_get(context, :cms_site)
        raise CmsTagError.new(':cms_site was not passed in the rendering context') unless cms_site

        outer_tag = @params.fetch('outer_tag', 'ul')
        outer_class = @params.fetch('outer_class', nil)
        nested_outer_class = @params.fetch('nested_outer_class', nil)
        inner_tag = @params.fetch('inner_tag', 'li')
        inner_class = @params.fetch('inner_class', nil)

        slug = @params.fetch('slug', nil)
        raise CmsTagError.new('slug was not passed in the cms_menu tag') unless slug

        @menu = MomentumCms::Menu.for_site(cms_site).where(slug: slug).first!
        @menu_items = MomentumCms::MenuItem.roots.for_menu(@menu).to_a

        build_menu(@menu_items, nil, { outer_tag: outer_tag,
                                       outer_class: outer_class,
                                       nested_outer_class: nested_outer_class,
                                       inner_tag: inner_tag,
                                       inner_class: inner_class })


          # _cms_page = context.environments.first
          # _cms_page =_cms_page[:cms_page]
          # menu = if @params.has_key?('sub_menu_only')
          #          _cms_page_children = _cms_page.children
          #          menu = ''
          #          menu += '<ul class="nav nav-sidebar">' if _cms_page_children.length > 0
          #          _cms_page_children.each do |cms_page|
          #            menu += "<li><a href='#{cms_page.path}'>#{cms_page.published_content.label}</a></li>"
          #          end
          #          menu += '</ul>' if _cms_page_children.length > 0
          #          menu.html_safe
          #        elsif @params.has_key?('parent_page_only')
          #          menu = ''
          # 
          #          _cms_page_parent = _cms_page.parent
          #          if _cms_page_parent
          #            menu += '<ul class="nav nav-sidebar">'
          #            menu += "<li><a href='#{_cms_page_parent.path}'>#{_cms_page_parent.published_content.label}</a></li>"
          #            menu += '</ul>'
          #          end
          #          menu.html_safe
          #        else
          #          "  #{@params.to_yaml}  #{context.to_yaml}"
          #        end
          # menu


      rescue => e
        print_error_message(e, self, context, @params)
      end
    end

    Liquid::Template.register_tag 'cms_menu', CmsMenu
  end
end
