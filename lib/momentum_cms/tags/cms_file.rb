module MomentumCms
  module Tags
    class CmsFile < CmsBaseTag

      def render(context)
        cms_site = context_get(context, :cms_site)
        raise CmsTagError.new(':cms_site was not passed in the rendering context') unless cms_site

        id = @params.fetch('id', nil)
        slug = @params.fetch('slug', nil)

        file = if id
                 MomentumCms::File.for_site(cms_site).where(id: id).first
               elsif slug
                 MomentumCms::File.for_site(cms_site).where(slug: slug).first
               end

        raise CmsTagError.new('File not found') unless file

        file.file.url
      rescue => e
        print_error_message(e, self, context, @params)
      end

    end
    Liquid::Template.register_tag 'cms_file', CmsFile
  end
end
