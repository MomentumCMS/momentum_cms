module MomentumCms
  module Tags

    class CmsSnippet < CmsBaseTag
      def render(context)
        cms_site = context_get!(context, :cms_site)

        slug = params_get!('slug')

        snippet = MomentumCms::Snippet.for_site(cms_site).where(slug: slug).first
        raise CmsTagError.new('Snippet not found') unless snippet

        Liquid::Template.parse(snippet.value).render(context)
      rescue => e
        print_error_message(e, self, context, @params)
      end
    end
    Liquid::Template.register_tag 'cms_snippet', CmsSnippet
  end
end