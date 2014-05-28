module MomentumCms
  module Drops
    class CmsPage < Liquid::Drop
      def initialize(page)
        @page = page
      end

      def blocks
        @page.blocks.collect { |x| x }
      end

      def updated_at
        @page.updated_at
      end
    end
  end
end