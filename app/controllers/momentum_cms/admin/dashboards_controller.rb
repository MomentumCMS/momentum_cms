class MomentumCms::Admin::DashboardsController < MomentumCms::Admin::BaseController
  def index

  end

  def selector
    redirect_to cms_admin_site_dashboards_path(@current_momentum_cms_site) and return
  end
end
