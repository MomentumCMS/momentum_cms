require_relative '../rails_helper'

describe LayoutFieldService, 'Service' do
  context '#test_has_yield' do

    it 'should respond to has_yield' do
      template = create(:template, value: 'test {% cms_yield %}')
      tbs = LayoutFieldService.new(template)

      expect(tbs.valid_liquid?).to be true
      expect(tbs.has_field?(MomentumCms::Tags::CmsYield)).to be true

      template = create(:template, value: 'test')
      tbs = LayoutFieldService.new(template)
      expect(tbs.valid_liquid?).to be true
      expect(tbs.has_field?(MomentumCms::Tags::CmsYield)).to be false

      template = build(:template, value: 'test {% cms_yield')
      tbs = LayoutFieldService.new(template)
      expect(tbs.valid_liquid?).to be false
      expect(tbs.has_field?(MomentumCms::Tags::CmsYield)).to be false
    end
  end
end