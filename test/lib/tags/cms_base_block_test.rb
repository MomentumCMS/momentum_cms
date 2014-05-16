require_relative '../../test_helper'

class CmsBaseBlockTest < ActiveSupport::TestCase
  def test_base_block
    assert_nothing_raised do
      o = MomentumCms::Tags::CmsBaseBlock.new('tag', 'params', ['{% endtag %}'])
      assert o
      assert o.is_a?(Liquid::Block)
    end
  end
end