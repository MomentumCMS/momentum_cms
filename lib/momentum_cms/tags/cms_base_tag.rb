module MomentumCms
  module Tags

    class CmsBaseTag < Liquid::Tag
      include MomentumCms::Tags::CmsLiquidUtils
      attr_accessor :params
    end
  end
end