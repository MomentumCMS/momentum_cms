require_relative '../../rails_helper'

describe MomentumCms::PagesController, 'Controller' do

  before(:each) do
    @site = create(:site, host: 'test.host')
    request.host = @site.host

    @template = create(:template, site: @site)
    @page = create(:page, site: @site, template: @template)
    @page.reload
    @page.publish!

    @template_child = create(:template_child, site: @site)
    @template_child.parent = @template
    @template_child.save

    @page_child = create(:page_child, site: @site, template: @template_child)
    @page_child.parent = @page
    @page_child.save
    @page_child.reload
    @page_child.publish!
  end

  describe '#show' do

    it 'should render page' do
      get :show, id: @page.path
      expect(response).to have_http_status(200)
      expect(response.body).to eq "default "

      get :show, id: @page_child.path
      expect(response).to have_http_status(200)
      expect(response.body).to eq "default child"
    end

    it 'should 404 for invalid page' do
      get :show, id: '/something'
      expect(response).to have_http_status(404)
    end
  end

  describe '#css' do
    it 'should render css' do
      get :css, id: @page_child.id, format: 'css'
      expect(@page_child.parent).to eq @page
      expect(@page.template).to eq @page.template
      expect(@page.template.css).to eq '.default{}'
      expect(response).to have_http_status(200)

      get :css, id: @page.id, format: 'css'
      expect(response).to have_http_status(200)
    end

    it 'should render empty css on invalid page' do
      get :css, id: 0, format: 'css'
      expect(response).to have_http_status(404)
    end
  end

  describe '#js' do
    it 'should render js' do
      get :js, id: @page_child.id, format: 'js'
      expect(@page_child.parent).to eq @page
      expect(@page.template).to eq @page.template
      expect(@page.template.js).to eq 'var default;'
      expect(response).to have_http_status(200)

      get :js, id: @page.id, format: 'js'
      expect(response).to have_http_status(200)
    end

    it 'should render empty js on invalid page' do
      get :js, id: 0, format: 'js'
      expect(response).to have_http_status(404)
    end
  end
end
