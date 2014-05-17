require_relative '../../test_helper'

class CmsBaseBlockTest < ActiveSupport::TestCase
  def test_base_block
    assert_nothing_raised do
      o = MomentumCms::Tags::CmsBaseTag.new('tag', 'params', ['foo'])
      assert o
      assert o.is_a?(Liquid::Tag)
    end
  end
end