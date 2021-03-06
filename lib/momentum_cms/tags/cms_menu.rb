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
                content_tag(:a, menu_item.linkable.label, href: menu_item.linkable.path) +
                  build_menu(menu_item.children, menu_item, options)
              else
                content_tag(:a, menu_item.linkable.label, href: menu_item.linkable.path)
              end
            end
          end.join('').html_safe
        end
      end

      def render(context)
        cms_site = context_get!(context, :cms_site)
        outer_tag = params_get('outer_tag', 'ul')
        outer_class = params_get('outer_class')
        nested_outer_class = params_get('nested_outer_class')
        inner_tag = params_get('inner_tag', 'li')
        inner_class = params_get('inner_class')

        identifier = params_get!('identifier')

        @menu = MomentumCms::Menu.for_site(cms_site).where(identifier: identifier).first!
        @menu_items = MomentumCms::MenuItem.roots.for_menu(@menu).to_a

        build_menu(@menu_items, nil, { outer_tag: outer_tag,
                                       outer_class: outer_class,
                                       nested_outer_class: nested_outer_class,
                                       inner_tag: inner_tag,
                                       inner_class: inner_class })
      rescue => e
        print_error_message(e, self, context, @params)
      end
    end

    Liquid::Template.register_tag 'cms_menu', CmsMenu
  end
end
