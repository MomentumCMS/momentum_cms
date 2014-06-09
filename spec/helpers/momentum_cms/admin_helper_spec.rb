require_relative '../../rails_helper'

describe MomentumCms::AdminHelper, 'Helper' do

  before(:each) do
    @current_momentum_cms_site = create(:site)
  end

  context '.momentum_page_path' do
    it 'should return the correct admin page path' do
      @momentum_cms_page = create(:page, site: @current_momentum_cms_site)
      expect(helper.momentum_page_path).to eq "/admin/sites/#{@current_momentum_cms_site.id}/pages/#{@momentum_cms_page.id}"

      @momentum_cms_page_another = create(:page, site: @current_momentum_cms_site, slug: 'foo', identifier: 'foo')
      expect(helper.momentum_page_path(@momentum_cms_page_another)).to eq "/admin/sites/#{@current_momentum_cms_site.id}/pages/#{@momentum_cms_page_another.id}"
    end
  end

  context '.momentum_pages_path' do
    it 'should return the correct admin pages path' do
      expect(helper.momentum_pages_path).to eq "/admin/sites/#{@current_momentum_cms_site.id}/pages"
    end
  end

  context '.edit_momentum_page_path' do
    it 'should return the correct admin edit page path' do
      @momentum_cms_page = create(:page, site: @current_momentum_cms_site)
      expect(helper.edit_momentum_page_path).to eq "/admin/sites/#{@current_momentum_cms_site.id}/pages/#{@momentum_cms_page.id}/edit"

      @momentum_cms_page_another = create(:page, site: @current_momentum_cms_site, slug: 'foo', identifier: 'foo')
      expect(helper.edit_momentum_page_path(@momentum_cms_page_another)).to eq "/admin/sites/#{@current_momentum_cms_site.id}/pages/#{@momentum_cms_page_another.id}/edit"
    end
  end

  context '.new_momentum_page_path' do
    it 'should return the correct admin new page path' do
      expect(helper.new_momentum_page_path).to eq "/admin/sites/#{@current_momentum_cms_site.id}/pages/new"
    end
  end

  context '.momentum_fields_path_for' do
    it 'should return the correct admin field ajax page' do

      @page = create(:page)
      expect(helper.momentum_fields_path_for(@page)).to eq '/admin/sites/1/pages/fields'

      @document = create(:document)
      expect(helper.momentum_fields_path_for(@document)).to eq '/admin/sites/1/documents/fields'

      @template = create(:template)
      expect { helper.momentum_fields_path_for(@template) }.to raise_error
    end
  end
end
