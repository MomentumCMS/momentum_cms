require_relative '../test_helper'

class TemplateBlockServiceTest < ActiveSupport::TestCase
  def setup

  end

  def test_has_yield
    template = MomentumCms::Template.create(label: 'test', value: 'test {% cms_yield %}')
    tbs = TemplateBlockService.new(template)
    assert tbs.valid_liquid?
    assert tbs.has_block?(MomentumCms::Tags::CmsYield)

    template = MomentumCms::Template.create(label: 'test', value: 'test')
    tbs = TemplateBlockService.new(template)
    assert tbs.valid_liquid?
    refute tbs.has_block?(MomentumCms::Tags::CmsYield)

    template = MomentumCms::Template.create(label: 'test', value: 'test {% cms_yield')
    tbs = TemplateBlockService.new(template)
    refute tbs.valid_liquid?
    refute tbs.has_block?(MomentumCms::Tags::CmsYield)
  end
end
