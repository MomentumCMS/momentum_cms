require_relative '../../../rails_helper'

describe MomentumCms::Admin::MenusController, 'Controller' do

  before(:each) do
    @site = create(:site)
    @menu = create(:menu, site: @site)
  end

  context '#index' do
    it 'should return all the menus inside a site' do
      get :index, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:momentum_cms_menus)).to include(@menu)
    end
  end

  context '#new' do
    it 'should display the new menu form' do
      get :new, site_id: @site.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      expect(assigns(:momentum_cms_menu).present?).to be true
      expect(assigns(:momentum_cms_menu).is_a?(MomentumCms::Menu)).to be true
      expect(assigns(:momentum_cms_menu).new_record?).to be true
    end
  end

  context '#create' do
    it 'should create a valid menu' do
      expect {
        post :create, site_id: @site.id, momentum_cms_menu: {
          label: 'Test Create',
          identifier: 'test-create'
        }
        expect(response).to have_http_status(:redirect)
        menu = MomentumCms::Menu.last
        expect(response).to redirect_to(edit_cms_admin_site_menu_path(@site, menu))
      }.to change { MomentumCms::Menu.count }.by(1)
    end

    it 'should not create an invalid menu' do
      expect {
        post :create, site_id: @menu.site.id, momentum_cms_menu: {
          label: 'Test Create',
          identifier: @menu.identifier
        }
        expect(response).to render_template(:new)
      }.to change { MomentumCms::Menu.count }.by(0)
    end
  end

  context '#edit' do
    it 'should show the edit form for a valid menu' do
      get :edit, site_id: @site.id, id: @menu
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it 'should not show the edit form for a non existing menu' do
      get :edit, site_id: @site.id, id: 0
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(cms_admin_site_menus_path)
    end
  end

  context '#update' do
    it 'should update a valid menu' do
      put :update,
          site_id: @site.id,
          id: @menu,
          momentum_cms_menu: {
            label: 'New Label'
          }
      @menu.reload
      expect(@menu.label).to eq 'New Label'
    end

    it 'should not update an invalid valid menu' do
      put :update,
          site_id: @site.id,
          id: @menu,
          momentum_cms_menu: {
            label: '',
            identifier: ''
          }
      @menu.reload
      expect(response).to render_template(:edit)
      expect(@menu.label).to_not eq ''
    end
  end

  context '#destroy' do
    it 'should destroy a valid menu' do
      expect {
        delete :destroy, site_id: @site.id, id: @menu
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Menu.count }.by(-1)
      expect { @menu.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should not destroy an invalid menu' do
      expect {
        delete :destroy, site_id: @site.id, id: 0
        expect(response).to have_http_status(:redirect)
      }.to change { MomentumCms::Menu.count }.by(0)
    end
  end
end
