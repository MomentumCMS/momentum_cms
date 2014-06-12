require_relative '../../../rails_helper'

describe MomentumCms::Admin::TemplatesController, type: :controller do
  before(:each) do
    @site = create(:site)
    @template = create(:template, site: @site)
  end

  context '#index' do
    it 'should return all the templates inside a site' do
      get :index, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:momentum_cms_templates)).to include(@template)
    end
  end

  context '#new' do
    it 'should display the new template form' do
      get :new, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      expect(assigns(:momentum_cms_templates).present?).to be true
      expect(assigns(:momentum_cms_template).present?).to be true
      expect(assigns(:momentum_cms_template).is_a?(MomentumCms::Template)).to be true
      expect(assigns(:momentum_cms_template).new_record?).to be true
    end
  end

  context '#create' do
    it 'should create a valid template' do
      expect {
        post :create, site_id: @site.id, momentum_cms_template: {
            label: 'Test Create',
            identifier: 'test-create'
        }
        expect(response).to have_http_status(:redirect)
        template = MomentumCms::Template.last
        expect(response).to redirect_to(edit_cms_admin_site_template_path(@site, template))
      }.to change { MomentumCms::Template.count }.by(1)
    end

    it 'should create a valid template with parent' do
      expect {
        post :create, site_id: @site.id, momentum_cms_template: {
            label: 'Test Create',
            parent_id: @template.id,
            identifier: 'test-create'
        }
        expect(response).to have_http_status(:redirect)
        template = MomentumCms::Template.last
        expect(response).to redirect_to(edit_cms_admin_site_template_path(@site, template))
      }.to change { MomentumCms::Template.count }.by(1)
    end

    it 'should not create an invalid template' do
      expect {
        post :create, site_id: @template.site.id, momentum_cms_template: {
            label: 'Test Create',
            identifier: @template.identifier
        }
        expect(response).to render_template(:new)
      }.to change { MomentumCms::Template.count }.by(0)
    end
  end

  context '#edit' do
    it 'should show the edit form for a valid template' do
      get :edit, site_id: @site.id, id: @template
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'should not show the edit form for a non existing template' do
      get :edit, site_id: @site.id, id: 0
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(cms_admin_site_templates_path)
    end
  end

  context '#update' do
    it 'should update a valid template' do
      put :update,
          site_id: @site.id,
          id: @template,
          momentum_cms_template: {
              label: 'New Label'
          }
      @template.reload
      expect(@template.label).to eq 'New Label'
    end

    it 'should not update an invalid valid template' do
      put :update,
          site_id: @site.id,
          id: @template,
          momentum_cms_template: {
              label: '',
              identifier: ''
          }
      @template.reload
      expect(response).to render_template(:edit)
      expect(@template.label).to_not eq ''
    end
  end

  context '#destroy' do
    it 'should destroy a valid template' do
      expect {
        delete :destroy, site_id: @site.id, id: @template
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Template.count }.by(-1)
      expect { @template.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should not destroy a permanent template' do
      @template.update_attributes({permanent_record: true})
      expect {
        delete :destroy, site_id: @site.id, id: @template
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Template.count }.by(0)
      expect(@template.persisted?).to be true
    end

    it 'should not destroy an invalid template' do
      expect {
        delete :destroy, site_id: @site.id, id: 0
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Template.count }.by(0)
    end
  end
end