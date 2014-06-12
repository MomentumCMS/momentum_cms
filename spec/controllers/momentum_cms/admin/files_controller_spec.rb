require_relative '../../../rails_helper'

describe MomentumCms::Admin::FilesController, type: :controller do

  before(:each) do
    @site = create(:site)
    @file = create(:file, site: @site)
  end

  context '#index' do
    it 'should return all the files inside a site' do
      get :index, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:momentum_cms_files)).to include(@file)
    end
  end

  context '#new' do
    it 'should display the new file form' do
      get :new, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      expect(assigns(:momentum_cms_file).present?).to be true
      expect(assigns(:momentum_cms_file).is_a?(MomentumCms::File)).to be true
      expect(assigns(:momentum_cms_file).new_record?).to be true
    end
  end

  context '#create' do
    it 'should create a valid file' do
      expect {
        post :create, site_id: @site.id, momentum_cms_file: {
          label: 'Test Create',
          identifier: 'test-create'
        }
        expect(response).to have_http_status(:redirect)
        file = MomentumCms::File.last
        expect(response).to redirect_to(edit_cms_admin_site_file_path(@site, file))
      }.to change { MomentumCms::File.count }.by(1)
    end

    it 'should not create an invalid file' do
      expect {
        post :create, site_id: @file.site.id, momentum_cms_file: {
          label: 'Test Create',
          identifier: @file.identifier
        }
        expect(response).to render_template(:new)
      }.to change { MomentumCms::File.count }.by(0)
    end
  end

  context '#edit' do
    it 'should show the edit form for a valid file' do
      get :edit, site_id: @site.id, id: @file
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'should not show the edit form for a non existing file' do
      get :edit, site_id: @site.id, id: 0
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(cms_admin_site_files_path)
    end
  end

  context '#update' do
    it 'should update a valid file' do
      put :update,
          site_id: @site.id,
          id: @file,
          momentum_cms_file: {
            label: 'New Label'
          }
      @file.reload
      expect(@file.label).to eq 'New Label'
    end

    it 'should not update an invalid valid file' do
      put :update,
          site_id: @site.id,
          id: @file,
          momentum_cms_file: {
            label: '',
            identifier: ''
          }
      @file.reload
      expect(response).to render_template(:edit)
      expect(@file.label).to_not eq ''
    end
  end

  context '#destroy' do
    it 'should destroy a valid file' do
      expect {
        delete :destroy, site_id: @site.id, id: @file
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::File.count }.by(-1)
      expect { @file.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should not destroy an invalid file' do
      expect {
        delete :destroy, site_id: @site.id, id: 0
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::File.count }.by(0)
    end
  end
end
