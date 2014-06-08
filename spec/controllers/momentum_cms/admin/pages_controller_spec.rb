require_relative '../../../rails_helper'

describe MomentumCms::Admin::PagesController, 'Controller' do
  before(:each) do
    @site = create(:site)
    @template = create(:template, site: @site)
    @page = create(:page, site: @site, template: @template)
  end

  context '#index' do
    it 'should return all the pages inside a site' do
      get :index, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:momentum_cms_pages)).to include(@page)
    end
  end

  context '#new' do
    it 'should display the new page form' do
      get :new, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      expect(assigns(:momentum_cms_parent_pages).present?).to be true
      expect(assigns(:momentum_cms_page).present?).to be true
      expect(assigns(:momentum_cms_page).is_a?(MomentumCms::Page)).to be true
      expect(assigns(:momentum_cms_page).new_record?).to be true
    end
  end

  context '#create' do
    it 'should create a valid page' do
      expect {
        post :create, site_id: @site.id, momentum_cms_page: {
            template_id: @template.id,
            label: 'Test Create',
            identifier: 'test-create',
            slug: 'test-create'
        }
        expect(response).to have_http_status(:redirect)
        page = MomentumCms::Page.last
        expect(response).to redirect_to(edit_cms_admin_site_page_path(@site, page))
      }.to change { MomentumCms::Page.count }.by(1)
    end

    it 'should create a valid page with parent' do
      expect {
        post :create, site_id: @site.id, momentum_cms_page: {
            template_id: @template.id,
            label: 'Test Create',
            parent_id: @page.id,
            slug: 'test-create-another',
            identifier: 'test_create_another'
        }
        expect(response).to have_http_status(:redirect)
        page = MomentumCms::Page.last
        expect(response).to redirect_to(edit_cms_admin_site_page_path(@site, page))
      }.to change { MomentumCms::Page.count }.by(1)
    end

    it 'should not create an invalid page' do
      expect {
        post :create, site_id: @page.site.id, momentum_cms_page: {
            label: 'Test Create',
            identifier: @page.identifier
        }
        expect(response).to render_template(:new)
      }.to change { MomentumCms::Page.count }.by(0)
    end
  end

  context '#edit' do
    it 'should show the edit form for a valid page' do
      get :edit, site_id: @site.id, id: @page
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'should not show the edit form for a non existing page' do
      get :edit, site_id: @site.id, id: 0
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(cms_admin_site_pages_path)
    end
  end

  context '#update' do
    it 'should update a valid page' do
      put :update,
          site_id: @site.id,
          id: @page,
          momentum_cms_page: {
              label: 'New Label'
          }
      @page.reload
      expect(@page.label).to eq 'New Label'
    end

    it 'should not update an invalid valid page' do
      put :update,
          site_id: @site.id,
          id: @page,
          momentum_cms_page: {
              label: '',
              identifier: ''
          }
      @page.reload
      expect(response).to render_template(:edit)
      expect(@page.label).to_not eq ''
    end
  end

  context '#destroy' do
    it 'should destroy a valid page' do
      expect {
        delete :destroy, site_id: @site.id, id: @page
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Page.count }.by(-1)
      expect { @page.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should not destroy an invalid page' do
      expect {
        delete :destroy, site_id: @site.id, id: 0
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Page.count }.by(0)
    end
  end
end