module MomentumCms
  module Tags
    class CmsYieldTag <CmsBaseTag
      def render(context)
        context.environments.first[:yield]
      rescue
        ''
      end
    end
    Liquid::Template.register_tag 'cms_yield', CmsYieldTag
  end
end
