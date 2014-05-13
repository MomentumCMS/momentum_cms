class MomentumCms::Admin::BaseController < ApplicationController
  layout 'momentum_cms/admin/application'

  include MomentumCms.configuration.admin_authentication.to_s.constantize

  before_action :authenticate

  before_action :load_sites
  before_action :load_site
  before_action :load_fixtures

  include MomentumCms::I18nLocale

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

  def load_fixtures
    return unless MomentumCms.configuration.site_fixtures_enabled.is_a?(Array)
    MomentumCms.configuration.site_fixtures_enabled.each do |fixture|
      MomentumCms::Fixture::Importer.new({ source: fixture }).import!
    end
    flash.now[:danger] = 'Fixtures enabled, all changes will be discarded.'
  end
end
