module MomentumCms
  module Tags
    class CmsFile < CmsBaseTag



      def render(context)
        context.environments.first[:yield]
      rescue
        ''
      end
    end
    Liquid::Template.register_tag 'cms_yield', CmsYield
  end
end
