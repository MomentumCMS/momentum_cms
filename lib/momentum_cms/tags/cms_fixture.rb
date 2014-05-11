module MomentumCms
  module Tags
    class CmsFixtureBlockTag < CmsBaseBlock
      def initialize(tag_name, params, tokens)
        super
        @params = sanatize_params(params)
        @params = parse_params(@params)
      end
    end
    Liquid::Template.register_tag 'cms_fixture', CmsFixtureBlockTag
  end
end