require_relative '../rails_helper'

describe TemplateBlockService, 'Service' do
  context '#test_has_yield' do

    it 'should respond to has_yield' do
      template = create(:template, value: 'test {% cms_yield %}')
      tbs = TemplateBlockService.new(template)

      expect(tbs.valid_liquid?).to be true
      expect(tbs.has_block?(MomentumCms::Tags::CmsYield)).to be true

      template = create(:template, value: 'test')
      tbs = TemplateBlockService.new(template)
      expect(tbs.valid_liquid?).to be true
      expect(tbs.has_block?(MomentumCms::Tags::CmsYield)).to be false

      template = create(:template, value: 'test {% cms_yield')
      tbs = TemplateBlockService.new(template)
      expect(tbs.valid_liquid?).to be false
      expect(tbs.has_block?(MomentumCms::Tags::CmsYield)).to be false
    end
  end
end