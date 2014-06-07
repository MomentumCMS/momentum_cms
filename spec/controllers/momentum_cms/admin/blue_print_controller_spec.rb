require 'rails_helper'

describe MomentumCms::Admin::BluePrintsController, 'Controller' do
  before(:each) do
    @site = create(:site)
    @blue_print = create(:blue_print, site: @site)
  end

  context '#index' do
    it 'should return all the blue prints inside a site' do
      get :index, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:momentum_cms_blue_prints)).to include(@blue_print)
    end
  end

  context '#new' do
    it 'should display the new blue print form' do
      get :new, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      expect(assigns(:momentum_cms_blue_prints).present?).to be true
      expect(assigns(:momentum_cms_blue_print).present?).to be true
      expect(assigns(:momentum_cms_blue_print).is_a?(MomentumCms::BluePrint)).to be true
      expect(assigns(:momentum_cms_blue_print).new_record?).to be true
    end
  end

  context '#create' do
    it 'should create a valid blue print' do
      expect {
        post :create, site_id: @site.id, momentum_cms_blue_print: {
            label: 'Test Create',
            identifier: 'test-create'
        }
        expect(response).to have_http_status(:redirect)
        blue_print = MomentumCms::BluePrint.last
        expect(response).to redirect_to(edit_cms_admin_site_blue_print_path(@site, blue_print))
      }.to change { MomentumCms::BluePrint.count }.by(1)
    end

    it 'should create a valid blue print with parent' do
      expect {
        post :create, site_id: @site.id, momentum_cms_blue_print: {
            label: 'Test Create',
            parent_id: @blue_print.id,
            identifier: 'test-create'
        }
        expect(response).to have_http_status(:redirect)
        blue_print = MomentumCms::BluePrint.last
        expect(response).to redirect_to(edit_cms_admin_site_blue_print_path(@site, blue_print))
      }.to change { MomentumCms::BluePrint.count }.by(1)
    end

    it 'should not create an invalid blue print' do
      expect {
        post :create, site_id: @blue_print.site.id, momentum_cms_blue_print: {
            label: 'Test Create',
            identifier: @blue_print.identifier
        }
        expect(response).to render_template(:new)
      }.to change { MomentumCms::BluePrint.count }.by(0)
    end
  end

  context '#edit' do
    it 'should show the edit form for a valid blue_print' do
      get :edit, site_id: @site.id, id: @blue_print
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'should not show the edit form for a non existing blue print' do
      get :edit, site_id: @site.id, id: 0
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(cms_admin_site_blue_prints_path)
    end
  end

  context '#update' do
    it 'should update a valid blue print' do
      put :update,
          site_id: @site.id,
          id: @blue_print,
          momentum_cms_blue_print: {
              label: 'New Label'
          }
      @blue_print.reload
      expect(@blue_print.label).to eq 'New Label'
    end

    it 'should not update an invalid valid blue print' do
      put :update,
          site_id: @site.id,
          id: @blue_print,
          momentum_cms_blue_print: {
              label: '',
              identifier: ''
          }
      @blue_print.reload
      expect(response).to render_template(:edit)
      expect(@blue_print.label).to_not eq ''
    end
  end

  context '#destroy' do
    it 'should destroy a valid blue print' do
      expect {
        delete :destroy, site_id: @site.id, id: @blue_print
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::BluePrint.count }.by(-1)
      expect { @blue_print.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should not destroy a permanent blue print' do
      @blue_print.update_attributes({permanent_record: true})
      expect {
        delete :destroy, site_id: @site.id, id: @blue_print
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::BluePrint.count }.by(0)
      expect(@blue_print.persisted?).to be true
    end

    it 'should not destroy an invalid blue print' do
      expect {
        delete :destroy, site_id: @site.id, id: 0
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::BluePrint.count }.by(0)
    end
  end
end