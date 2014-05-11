module MomentumCms
  module Tags
    class CmsFixture < CmsBaseBlock
   
    end
    Liquid::Template.register_tag 'cms_fixture', CmsFixture
  end
end