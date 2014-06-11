require_relative '../rails_helper'

describe LayoutFieldService, 'Service' do

  before(:each) do
    @site = create(:site)

    @template = create(:template, site: @site)
    @template.field_templates.create!(identifier: 'foo', label: 'foo')
    @template.field_templates.create!(identifier: 'bar', label: 'bar')

    @blue_print = create(:blue_print, site: @site)
    @blue_print.field_templates.create!(identifier: 'foo', label: 'foo')
    @blue_print.field_templates.create!(identifier: 'bar', label: 'bar')
  end

  context '.initialize' do
    it 'should create a new service' do
      lfs = LayoutFieldService.new(@template)
      expect(lfs.is_a?(LayoutFieldService)).to be true
      lfs = LayoutFieldService.new(@blue_print)
      expect(lfs.is_a?(LayoutFieldService)).to be true
      expect { LayoutFieldService.new(@site) }.to raise_error
    end
  end

  context '#get_identifiers' do
    it 'should return a collection of identifiers for templates' do
      lfs = LayoutFieldService.new(@template)
      identifiers = lfs.get_identifiers
      expect(identifiers.include?('MomentumCms::Template//template_identifier::foo')).to be true
      expect(identifiers.include?('MomentumCms::Template//template_identifier::bar')).to be true
    end

    it 'should return a collection of identifiers for blue prints' do
      lfs = LayoutFieldService.new(@blue_print)
      identifiers = lfs.get_identifiers
      expect(identifiers.include?('MomentumCms::BluePrint//blue_print_identifier::foo')).to be true
      expect(identifiers.include?('MomentumCms::BluePrint//blue_print_identifier::bar')).to be true
    end
  end

  context '#has_field?' do
    it 'should respond to fields of a template' do
      template = create(:template, value: 'test {% cms_yield %}')
      lfs = LayoutFieldService.new(template)
      expect(lfs.has_field?(MomentumCms::Tags::CmsYield)).to be true
      expect(lfs.has_field?(MomentumCms::Tags::CmsField)).to be false
    end
  end

  context '#get_fields' do
    it 'should get all the fields of a template' do
      lfs = LayoutFieldService.new(@template)
      fields = lfs.get_fields
      expect(fields.length == 2).to be true
    end

    it 'should get all the fields of a blue print' do
      lfs = LayoutFieldService.new(@blue_print)
      fields = lfs.get_fields
      expect(fields.length == 2).to be true
    end
  end

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