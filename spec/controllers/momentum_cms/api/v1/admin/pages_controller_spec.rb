require_relative '../../../../../rails_helper'

describe MomentumCms::Api::V1::Admin::PagesController, type: :controller do

  before(:each) do
    @site = create(:site)
    @template = create(:template, site: @site)
    @page = create(:page, site: @site)
  end

  context '#index' do
    it 'should get the pages of a given site' do
      get :index, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(assigns(:site).present?).to be true
      expect(assigns(:pages).present?).to be true
      expect(json).to have_key('pages')
      expect(json['pages'][0]['id']).to eq(@page.id)
      expect(json['pages'][0]['label']).to eq(@page.label)
      expect(json['pages'][0]['identifier']).to eq(@page.identifier)
    end
  end

  context '#create' do
    it 'should create a valid page' do
      expect {
        post :create, page: {
          label: 'Api Page',
          identifier: 'api-page',
          slug: 'api-page',
          template_id: @template.id,
          site_id: @site.id
        }
      }.to change { MomentumCms::Page.count }.by(1)

      page = MomentumCms::Page.last
      expect(response).to have_http_status(:success)
      expect(assigns(:page).present?).to be true

      expect(json).to have_key('page')

      expect(json['page']['label']).to eq page.label
      expect(json['page']['identifier']).to eq page.identifier
      expect(json['page']['slug']).to eq page.slug
    end

    it 'should not create an invalid page' do
      expect {
        post :create, page: {}
      }.to change { MomentumCms::Page.count }.by(0)
      expect(response).to have_http_status(422)
      expect(assigns(:page).present?).to be true
      expect(json).to have_key('errors')
      expect(json['errors']['slug'].present?).to be true
      expect(json['errors']['identifier'].present?).to be true
      expect(json['errors']['layout'].present?).to be true
    end
  end

  context '#update' do
    it 'should update a valid page' do
      patch :update, id: @page.id, page: {
        label: 'New Label',
        slug: 'new-label'
      }
      expect(response).to have_http_status(:success)
      @page.reload
      expect(@page.label).to eq 'New Label'
      expect(@page.slug).to eq 'new-label'
    end

    it 'should not update an invalid page' do
      patch :update, id: @page.id, page: {
        label: 'New Label',
        slug: nil
      }
      expect(response).to have_http_status(422)
      expect(json).to have_key('errors')
    end
  end

  context '#destroy' do
    it 'should destroy a valid page' do
      expect {
        delete :destroy, id: @page.id
        expect(response).to have_http_status(:success)
      }.to change { MomentumCms::Page.count }.by(-1)
    end
  end
end
