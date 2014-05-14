module MomentumCms
  module Tags

    class CmsBreadcrumb < CmsBaseTag
      def render(context)
        cms_page = context_get(context, :cms_page)
        raise CmsTagError.new(':cms_page was not passed in the rendering context') unless cms_page

        outer_tag = @params.fetch('outer_tag', 'ol')
        raise CmsTagError.new(':outer_tag was not passed in the cms_breadcrumb tag') unless outer_tag

        inner_tag = @params.fetch('inner_tag', 'li')
        raise CmsTagError.new(':inner_tag was not passed in the cms_breadcrumb tag') unless inner_tag

        outer_class = @params.fetch('outer_class', nil)

        pages = MomentumCms::Page.ancestor_and_self!(cms_page)

        content_tag outer_tag.to_sym, class: outer_class do
          pages.collect do |page|
            content_tag inner_tag.to_sym do
              content_tag(:a, page.published_content.label, href: page.path)
            end
          end.join('').html_safe
        end

      rescue => e
        print_error_message(e, self, context, @params)
      end
    end
    Liquid::Template.register_tag 'cms_breadcrumb', CmsBreadcrumb
  end
end