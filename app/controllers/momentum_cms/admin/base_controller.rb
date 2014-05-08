class MomentumCms::Admin::BaseController < ApplicationController
  layout 'momentum_cms/admin/application'

  before_action :load_sites
  before_action :load_site

  def load_sites
    @momentum_cms_sites = MomentumCms::Site.all
  end

  def load_site
    @current_momentum_cms_site = if params[:site_id]
                                   MomentumCms::Site.where(id: params[:site_id]).first
                                 else
                                   MomentumCms::Site.where(host: request.host_with_port).first
                                 end

    if @current_momentum_cms_site.blank?
      @current_momentum_cms_site = MomentumCms::Site.first
    end

    if @current_momentum_cms_site.blank?
      redirect_to new_cms_admin_site_path and return
    end
  end

end
