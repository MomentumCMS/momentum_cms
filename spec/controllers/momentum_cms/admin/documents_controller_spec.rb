require_relative '../../../rails_helper'

describe MomentumCms::Admin::DocumentsController, type: :controller do
  before(:each) do
    @site = create(:site)
    @blue_print = create(:blue_print, site: @site)
    @document = create(:document, site: @site, blue_print: @blue_print)
  end

  context '#index' do
    it 'should return all the documents inside a site' do
      get :index, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:momentum_cms_documents)).to include(@document)
    end
  end

  context '#new' do
    it 'should display the new document form' do
      get :new, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      expect(assigns(:momentum_cms_document).present?).to be true
      expect(assigns(:momentum_cms_document).is_a?(MomentumCms::Document)).to be true
      expect(assigns(:momentum_cms_document).new_record?).to be true
    end
  end

  context '#create' do
    it 'should create a valid document' do
      expect {
        post :create, site_id: @site.id, momentum_cms_document: {
          blue_print_id: @blue_print.id,
          label: 'Test Create',
          identifier: 'test-create'
        }
        expect(response).to have_http_status(:redirect)
        document = MomentumCms::Document.last
        expect(response).to redirect_to(edit_cms_admin_site_document_path(@site, document))
      }.to change { MomentumCms::Document.count }.by(1)
    end

    it 'should create a valid document with parent' do
      expect {
        post :create, site_id: @site.id, momentum_cms_document: {
          blue_print_id: @blue_print.id,
          label: 'Test Create',
          parent_id: @document.id,
          identifier: 'test_create_another'
        }
        expect(response).to have_http_status(:redirect)
        document = MomentumCms::Document.last
        expect(response).to redirect_to(edit_cms_admin_site_document_path(@site, document))
      }.to change { MomentumCms::Document.count }.by(1)
    end

    it 'should not create an invalid document' do
      expect {
        post :create, site_id: @document.site.id, momentum_cms_document: {
          label: 'Test Create',
          identifier: @document.identifier
        }
        expect(response).to render_template(:new)
      }.to change { MomentumCms::Document.count }.by(0)
    end
  end

  context '#edit' do
    it 'should show the edit form for a valid document' do
      get :edit, site_id: @site.id, id: @document
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'should not show the edit form for a non existing document' do
      get :edit, site_id: @site.id, id: 0
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(cms_admin_site_documents_path)
    end

    it 'should load a revision IFF a revision number is given' do
      @document.publish!

      get :edit, site_id: @site.id, id: @document
      revision_data = assigns(:momentum_cms_document_revision_data)
      expect(revision_data.nil?).to be true


      get :edit, site_id: @site.id, id: @document, revision: 1
      revision_data = assigns(:momentum_cms_document_revision_data)
      expect(revision_data.nil?).to be false
    end
  end

  context '#update' do
    it 'should update a valid document' do
      put :update,
          site_id: @site.id,
          id: @document,
          momentum_cms_document: {
            label: 'New Label'
          }
      @document.reload
      expect(@document.label).to eq 'New Label'
    end

    it 'should not update an invalid valid document' do
      put :update,
          site_id: @site.id,
          id: @document,
          momentum_cms_document: {
            label: '',
            identifier: ''
          }
      @document.reload
      expect(response).to render_template(:edit)
      expect(@document.label).to_not eq ''
    end
  end

  context '#destroy' do
    it 'should destroy a valid document' do
      expect {
        delete :destroy, site_id: @site.id, id: @document
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Document.count }.by(-1)
      expect { @document.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should not destroy an invalid document' do
      expect {
        delete :destroy, site_id: @site.id, id: 0
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Document.count }.by(0)
    end
  end

  context '#publish' do
    it 'should publish an unpublished document' do
      expect(@document.published?).to be false
      post :publish, site_id: @site.id, id: @document
      @document.reload
      expect(@document.published?).to be true
    end
  end

  context '#unpublish' do
    it 'should unpublish a published document' do
      @document.publish!
      @document.reload
      expect(@document.published?).to be true
      post :unpublish, site_id: @site.id, id: @document
      @document.reload
      expect(@document.published?).to be false
    end

    it 'should unpublish an unpublished document' do
      expect(@document.published?).to be false
      post :unpublish, site_id: @site.id, id: @document
      @document.reload
      expect(@document.published?).to be false
    end
  end

  context '#fields' do
    it 'should render nothing if an invalid blue print is given' do
      get :fields, site_id: @site.id
      expect(response.body).to be_blank
      get :fields, site_id: @site.id, blue_print_id: 0
      expect(response.body).to be_blank
    end

    it 'should render fields for a blue print without a document' do
      @blue_print.field_templates.destroy_all
      @blue_print.field_templates.create!(identifier: 'foo', label: 'foo')
      @blue_print.field_templates.create!(identifier: 'bar', label: 'bar')
      get :fields, site_id: @site.id, blue_print_id: @blue_print.id
      document = assigns(:momentum_cms_document)
      expect(document.persisted?).to be false
      expect(document.fields.length == 2).to be true
    end
  end
end
