require 'action_view'
module MomentumCms
  module Tags
    
    class CmsBaseTag < Liquid::Tag
      include ActionView::Helpers::AssetTagHelper
      include MomentumCms::Tags::CmsLiquidUtils
      attr_accessor :params
    end
  end
end