require 'action_view'
module MomentumCms
  module Tags

    class CmsBaseBlock < Liquid::Block
      include MomentumCms::Tags::CmsLiquidUtils
      attr_accessor :params
    end
  end
end