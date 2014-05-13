module MomentumCms
  module Tags
    class CmsYield <CmsBaseTag
      def render(context)
        context_get(context, :yield)
      end
    end
    Liquid::Template.register_tag 'cms_yield', CmsYield
  end
end
