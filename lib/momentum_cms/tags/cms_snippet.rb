module MomentumCms
  module Tags

    class CmsSnippet < CmsBaseTag
      def render(context)
        cms_site = context_get(context, :cms_site)
        raise CmsTagError.new(':cms_site was not passed in the rendering context') unless cms_site

        slug = @params.fetch(:slug, nil)
        raise CmsTagError.new(':slug was not passed in the cms_snippet tag') unless slug

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