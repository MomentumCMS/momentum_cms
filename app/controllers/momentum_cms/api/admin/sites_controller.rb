class MomentumCms::Api::Admin::SitesController < MomentumCms::Api::BaseController

  def index
    @sites = MomentumCms::Site.all
    render json: @sites
  end

  def create
    @site = MomentumCms::Site.create!(site_params)
    render json: @site
  end

private

  def site_params
    params.fetch(:site, {}).permit(:title,
                                   :label,
                                   :identifier,
                                   :host,
                                   :default_locale,
                                   :available_locales)
  end

end