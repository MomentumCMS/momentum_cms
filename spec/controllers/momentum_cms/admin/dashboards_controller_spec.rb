require_relative '../../../rails_helper'

describe MomentumCms::Admin::DashboardsController, 'Controller' do
  before(:each) do
    @site = create(:site)
  end

  context '#selector' do
    it 'should redirect to the dashboard' do
      get :selector, site_id: @site.id
      expect(response).to redirect_to(cms_admin_site_dashboards_path(assigns(:current_momentum_cms_site)))
    end
  end
end
