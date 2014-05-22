module MomentumCms
  module Tags

    class CmsBreadcrumb < CmsBaseTag
      def render(context)
        cms_page = context_get!(context, :cms_page)

        outer_tag = params_get!('outer_tag', 'ol')

        inner_tag = params_get!('inner_tag', 'li')

        outer_class =params_get('outer_class')

        inner_class = params_get('inner_class')

        pages = MomentumCms::Page.ancestor_and_self!(cms_page)

        content_tag outer_tag.to_sym, class: outer_class do
          pages.collect do |page|
            content_tag inner_tag.to_sym, class: inner_class do
              content_tag(:a, page.label, href: page.path)
            end
          end.join('').html_safe
        end

      rescue CmsTagError => e
        print_error_message(e, self, context, @params)
      end
    end
    Liquid::Template.register_tag 'cms_breadcrumb', CmsBreadcrumb
  end
end