module MomentumCms
  module Tags
    class CmsFile < CmsBaseTag

      def render(context)
        cms_site = context_get!(context, :cms_site)

        id = params_get('id')

        identifier = params_get('identifier')

        file = if id
                 MomentumCms::File.for_site(cms_site).where(id: id).first
               elsif identifier
                 MomentumCms::File.for_site(cms_site).where(identifier: identifier).first
               end

        raise CmsTagError.new('File not found') unless file

        file.file.url
      rescue CmsTagError => e
        print_error_message(e, self, context, @params)
      end

    end
    Liquid::Template.register_tag 'cms_file', CmsFile
  end
end
