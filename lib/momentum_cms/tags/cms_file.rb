module MomentumCms
  module Tags
    class CmsFile < CmsBaseTag

      def render(context)
        site = context_get(context, :cms_site)
        return '' unless site
        id = @params.fetch(:id, nil)
        slug = @params.fetch(:slug, nil)

        file = if id
                 MomentumCms::File.for_site(site).where(id: id).first
               elsif slug
                 MomentumCms::File.for_site(site).where(slug: slug).first
               end
        if file
          file.file.url
        else
          ''
        end
      end

    end
    Liquid::Template.register_tag 'cms_file', CmsFile
  end
end
