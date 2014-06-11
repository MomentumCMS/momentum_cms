require_relative '../../../rails_helper'

describe MomentumCms::Admin::SnippetsController, 'Controller' do
  before(:each) do
    @site = create(:site)
    @snippet = create(:snippet, site: @site)
  end

  context '#index' do
    it 'should return all the snippets inside a site' do
      get :index, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:momentum_cms_snippets)).to include(@snippet)
    end
  end

  context '#new' do
    it 'should display the new snippet form' do
      get :new, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      expect(assigns(:momentum_cms_snippet).present?).to be true
      expect(assigns(:momentum_cms_snippet).is_a?(MomentumCms::Snippet)).to be true
      expect(assigns(:momentum_cms_snippet).new_record?).to be true
    end
  end

  context '#create' do
    it 'should create a valid snippet' do
      expect {
        post :create, site_id: @site.id, momentum_cms_snippet: {
          label: 'Test Create',
          identifier: 'test-create'
        }
        expect(response).to have_http_status(:redirect)
        snippet = MomentumCms::Snippet.last
        expect(response).to redirect_to(edit_cms_admin_site_snippet_path(@site, snippet))
      }.to change { MomentumCms::Snippet.count }.by(1)
    end

    it 'should not create an invalid snippet' do
      expect {
        post :create, site_id: @snippet.site.id, momentum_cms_snippet: {
          label: 'Test Create',
          identifier: @snippet.identifier
        }
        expect(response).to render_template(:new)
      }.to change { MomentumCms::Snippet.count }.by(0)
    end
  end

  context '#edit' do
    it 'should show the edit form for a valid snippet' do
      get :edit, site_id: @site.id, id: @snippet
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'should not show the edit form for a non existing snippet' do
      get :edit, site_id: @site.id, id: 0
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(cms_admin_site_snippets_path)
    end
  end

  context '#update' do
    it 'should update a valid snippet' do
      put :update,
          site_id: @site.id,
          id: @snippet,
          momentum_cms_snippet: {
            label: 'New Label'
          }
      @snippet.reload
      expect(@snippet.label).to eq 'New Label'
    end

    it 'should not update an invalid valid snippet' do
      put :update,
          site_id: @site.id,
          id: @snippet,
          momentum_cms_snippet: {
            label: '',
            identifier: ''
          }
      @snippet.reload
      expect(response).to render_template(:edit)
      expect(@snippet.label).to_not eq ''
    end
  end

  context '#destroy' do
    it 'should destroy a valid snippet' do
      expect {
        delete :destroy, site_id: @site.id, id: @snippet
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Snippet.count }.by(-1)
      expect { @snippet.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should not destroy an invalid snippet' do
      expect {
        delete :destroy, site_id: @site.id, id: 0
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Snippet.count }.by(0)
    end
  end
end
