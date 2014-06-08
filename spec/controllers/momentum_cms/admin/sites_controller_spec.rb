require_relative '../../../rails_helper'

describe MomentumCms::Admin::SitesController, 'Controller' do
  before(:each) do
    @site = create(:site)
  end

  context '#index' do
    it 'should return all the sites' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:momentum_cms_sites)).to include(@site)
    end
  end

  context '#new' do
    it 'should display the new shite form' do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      expect(assigns(:momentum_cms_site).present?).to be true
      expect(assigns(:momentum_cms_site).is_a?(MomentumCms::Site)).to be true
      expect(assigns(:momentum_cms_site).new_record?).to be true
    end
  end

  context '#create' do
    it 'should create a valid site' do
      expect {
        post :create, momentum_cms_site: {
            label: 'test2',
            identifier: 'testtest',
            host: 'test2.dev'
        }
        expect(response).to have_http_status(:redirect)
        site = MomentumCms::Site.last
        expect(response).to redirect_to(edit_cms_admin_site_path(site))
      }.to change { MomentumCms::Site.count }.by(1)
    end

    it 'should not create an invalid template' do
      expect {
        post :create,
             momentum_cms_site: {
                 label: @site.label,
                 identifier: @site.identifier,
                 host: @site.host
             }
        expect(response).to render_template(:new)
      }.to change { MomentumCms::Template.count }.by(0)
    end
  end

  context '#edit' do
    it 'should show the edit form for a valid site' do
      get :edit, id: @site
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'should not show the edit form for a non existing site' do
      get :edit, id: 0
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(cms_admin_sites_path)
    end
  end

  context '#update' do
    it 'should update a valid template' do
      put :update,
          id: @site,
          momentum_cms_site: {
              label: 'New Label'
          }
      @site.reload
      expect(@site.label).to eq 'New Label'
    end

    it 'should not update an invalid valid template' do
      put :update,
          id: @site,
          momentum_cms_site: {
              label: ''
          }
      @site.reload
      expect(response).to render_template(:edit)
      expect(@site.label).to_not eq ''
    end
  end

  context '#destroy' do
    it 'should destroy a valid site' do
      expect {
        delete :destroy, id: @site
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Site.count }.by(-1)
      expect { @site.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should not destroy an invalid site' do
      expect {
        delete :destroy, id: 0
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Site.count }.by(0)
    end
  end
end
