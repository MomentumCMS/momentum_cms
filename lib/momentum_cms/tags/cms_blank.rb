module MomentumCms
  module Tags
    class CmsBlankBlock < CmsBaseBlock
    end
    Liquid::Template.register_tag 'cms_blank_block', CmsBlankBlock

    class CmsBlankTag < CmsBaseTag
    end
    Liquid::Template.register_tag 'cms_blank_tag', CmsBlankTag
  end
end